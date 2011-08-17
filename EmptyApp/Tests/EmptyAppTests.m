//
//  EmptyAppTests.m
//  Couchbase Mobile
//
//  Created by Jens Alfke on 7/8/11.
//  Copyright 2011 Couchbase, Inc. All rights reserved.
//

#import "EmptyAppTests.h"
#import <Couchbase/CouchbaseEmbeddedServer.h>

extern BOOL sUnitTesting;
extern CouchbaseEmbeddedServer* sCouchbase;  // Defined in EmptyAppDelegate.m

@implementation EmptyAppTests

- (void)setUp
{
    [super setUp];

    sUnitTesting = YES;
    STAssertNotNil(sCouchbase, nil);
    if (!sCouchbase.serverURL) {
        NSLog(@"Waiting for Couchbase server to start up...");
        NSDate* timeout = [NSDate dateWithTimeIntervalSinceNow: 10.0];
        while (!sCouchbase.serverURL && !sCouchbase.error && [timeout timeIntervalSinceNow] > 0) {
            [[NSRunLoop currentRunLoop] runUntilDate: [NSDate dateWithTimeIntervalSinceNow: 0.5]];
        }

        NSLog(@"===== EmptyAppTests: Server URL = %@", sCouchbase.serverURL);
    }
    STAssertNil(sCouchbase.error, nil);
    STAssertNotNil(sCouchbase.serverURL, nil);

    // Delete the test database if it was left behind:
    NSURL* url = [NSURL URLWithString: @"/unittestdb" relativeToURL: sCouchbase.serverURL];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL: url];
    request.HTTPMethod = @"DELETE";
    [NSURLConnection sendSynchronousRequest: request returningResponse: NULL error: NULL];
}

- (void)tearDown
{
    [super tearDown];
}


// This is for testing only! In a real app you would not want to send URL requests synchronously.
- (NSString*)send: (NSString*)method
           toPath: (NSString*)relativePath
             body: (NSString*)body
  responseHeaders: (NSDictionary**)outResponseHeaders
{
    NSLog(@"%@ %@", method, relativePath);
    NSURL* url = [NSURL URLWithString: relativePath relativeToURL: sCouchbase.serverURL];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL: url];
    request.HTTPMethod = method;
    request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    if (body) {
        request.HTTPBody = [body dataUsingEncoding: NSUTF8StringEncoding];
        [request addValue: @"application/json" forHTTPHeaderField: @"Content-Type"];
    }
    NSHTTPURLResponse* response = nil;
    NSError* error = nil;

    NSData* responseBody = [NSURLConnection sendSynchronousRequest: request
                                                 returningResponse: (NSURLResponse**)&response
                                                             error: &error];
    STAssertTrue(responseBody != nil && response != nil,
             @"Request to <%@> failed: %@", url.absoluteString, error);
    int statusCode = response.statusCode;
    STAssertTrue(statusCode < 300,
             @"Request to <%@> failed: HTTP error %i", url.absoluteString, statusCode);

    if (outResponseHeaders)
        *outResponseHeaders = response.allHeaderFields;
    NSString* responseStr = [[NSString alloc] initWithData: responseBody
                                                  encoding: NSUTF8StringEncoding];
    NSLog(@"Response (%d):\n%@", statusCode, responseStr);
    return [responseStr autorelease];
}

- (NSString*)send: (NSString*)method
           toPath: (NSString*)relativePath
             body: (NSString*)body {
    return [self send:method toPath:relativePath body:body responseHeaders:NULL];
}


- (void)test1_BasicOps
{
    [self send: @"GET" toPath: @"/" body: nil];
    [self send: @"PUT" toPath: @"/unittestdb" body: nil];
    [self send: @"GET" toPath: @"/unittestdb" body: nil];
    [self send: @"POST" toPath: @"/unittestdb/" body: @"{\"txt\":\"foobar\"}"];
    [self send: @"PUT" toPath: @"/unittestdb/doc1" body: @"{\"txt\":\"O HAI\"}"];
    [self send: @"GET" toPath: @"/unittestdb/doc1" body: nil];
    [self send: @"DELETE" toPath: @"/unittestdb" body: nil];
}


- (void)test2_UpdateViews {
    // Test that the ETag in a view response changes after the view contents change.
    [self send: @"PUT" toPath: @"/unittestdb" body: nil];
    [self send: @"PUT" toPath: @"/unittestdb/doc1" body: @"{\"txt\":\"O HAI\"}"];

    [self send: @"PUT" toPath: @"/unittestdb/_design/updateviews"
          body: @"{\"views\":{\"simple\":{\"map\":\"function(doc){emit(doc._id,null);}\"}}}"];

    NSDictionary* headers;
    [self send: @"GET" toPath: @"/unittestdb/_design/updateviews/_view/simple"
          body: nil responseHeaders: &headers];
    NSLog(@"ETag: %@", [headers objectForKey: @"ETag"]);
    NSString* eTag = [headers objectForKey: @"ETag"];
    STAssertNotNil(eTag, nil);
    [self send: @"GET" toPath: @"/unittestdb/_design/updateviews/_view/simple"
          body: nil responseHeaders: &headers];
    NSLog(@"ETag: %@", [headers objectForKey: @"ETag"]);
    STAssertEqualObjects([headers objectForKey: @"ETag"], eTag, @"View eTag isn't stable");

    [self send: @"PUT" toPath: @"/unittestdb/doc2" body: @"{\"txt\":\"KTHXBYE\"}"];

    [self send: @"GET" toPath: @"/unittestdb/_design/updateviews/_view/simple"
          body: nil responseHeaders: &headers];
    NSLog(@"ETag: %@", [headers objectForKey: @"ETag"]);
    STAssertFalse([eTag isEqualToString: [headers objectForKey: @"ETag"]], @"View didn't update");
}


- (void)test3_JSException
{
    // Make sure that if a JS exception is thrown by a view function, it doesn't crash Erlang.
    [self send: @"PUT" toPath: @"/unittestdb" body: nil];
    [self send: @"PUT" toPath: @"/unittestdb/doc1" body: @"{\"txt\":\"O HAI\"}"];
    [self send: @"PUT" toPath: @"/unittestdb/_design/exception"
          body: @"{\"views\":{\"oops\":{\"map\":\"function(){throw 'oops';}\"}}}"];
    [self send: @"GET" toPath: @"/unittestdb/_design/exception/_view/oops" body: nil];
}


@end
