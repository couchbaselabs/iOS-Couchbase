//
//  Couchbase_Empty_AppTests.m
//  Couchbase Empty AppTests
//
//  Created by Jens Alfke on 7/8/11.
//  Copyright 2011 Couchbase, Inc. All rights reserved.
//

#import "Couchbase_Empty_AppTests.h"
#import <Couchbase/Couchbase.h>

extern CouchbaseEmbeddedServer* sCouchbase;  // Defined in EmptyAppDelegate.m

@implementation Couchbase_Empty_AppTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}


// This is for testing only! In a real app you would not want to send URL requests synchronously.
- (void)send: (NSString*)method toPath: (NSString*)relativePath {
    NSLog(@"%@ %@", method, relativePath);
    NSURL* url = [NSURL URLWithString: relativePath relativeToURL: sCouchbase.serverURL];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL: url];
    request.HTTPMethod = method;
    NSURLResponse* response = nil;
    NSError* error = nil;
    
    NSData* body = [NSURLConnection sendSynchronousRequest: request
                                         returningResponse: &response
                                                     error: &error];
    NSAssert(body != nil && response != nil,
             @"Request to <%@> failed: %@", url.absoluteString, error);
    int statusCode = ((NSHTTPURLResponse*)response).statusCode;
    NSAssert(statusCode < 300,
             @"Request to <%@> failed: HTTP error %i", url.absoluteString, statusCode);
    
    NSString* responseStr = [[NSString alloc] initWithData: body encoding: NSUTF8StringEncoding];
    NSLog(@"Response (%d):\n%@", statusCode, responseStr);
    [responseStr release];
}


- (void)testExample
{
    NSDate* timeout = [NSDate dateWithTimeIntervalSinceNow: 10.0];
    while (!sCouchbase.serverURL && !sCouchbase.error) {
        [[NSRunLoop currentRunLoop] runUntilDate: timeout];
    }
    
    STAssertNil(sCouchbase.error, nil);
    STAssertNotNil(sCouchbase.serverURL, nil);
}

@end
