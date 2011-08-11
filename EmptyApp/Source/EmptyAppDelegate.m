//
//  EmptyAppDelegate.m
//  Couchbase Empty App
//
//  Created by Jens Alfke on 7/8/11.
//  Copyright 2011 CouchBase, Inc. All rights reserved.
//

#import "EmptyAppDelegate.h"


@implementation EmptyAppDelegate


BOOL sUnitTesting;
CouchbaseEmbeddedServer* sCouchbase;  // Used by the unit tests


@synthesize window = _window;
@synthesize serverURL = _serverURL;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSLog(@"------ Empty App: application:didFinishLaunchingWithOptions:");
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    
    // Initialize CouchDB:
    CouchbaseEmbeddedServer* cb = [[CouchbaseEmbeddedServer alloc] init];
    cb.delegate = self;
    NSAssert([cb start], @"Couchbase couldn't start! Error = %@", cb.error);
    sCouchbase = cb;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"------ Empty App: applicationWillResignActive");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"------ Empty App: applicationDidEnterBackground");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"------ Empty App: applicationWillEnterForeground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"------ Empty App: applicationDidBecomeActive");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"------ Empty App: applicationWillTerminate");
}


// This is for testing only! In a real app you would not want to send URL requests synchronously.
- (void)send: (NSString*)method toPath: (NSString*)relativePath body: (NSString*)body {
    NSLog(@"%@ %@", method, relativePath);
    NSURL* url = [NSURL URLWithString: relativePath relativeToURL: self.serverURL];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL: url];
    request.HTTPMethod = method;
    if (body) {
        request.HTTPBody = [body dataUsingEncoding: NSUTF8StringEncoding];
        [request addValue: @"application/json" forHTTPHeaderField: @"Content-Type"];
    }
    NSURLResponse* response = nil;
    NSError* error = nil;
    
    NSData* responseBody = [NSURLConnection sendSynchronousRequest: request
                                         returningResponse: &response
                                                     error: &error];
    NSAssert(responseBody != nil && response != nil,
             @"Request to <%@> failed: %@", url.absoluteString, error);
    int statusCode = ((NSHTTPURLResponse*)response).statusCode;
    NSAssert(statusCode < 300,
             @"Request to <%@> failed: HTTP error %i", url.absoluteString, statusCode);
    
    NSString* responseStr = [[NSString alloc] initWithData: responseBody
                                                  encoding: NSUTF8StringEncoding];
    NSLog(@"Response (%d):\n%@", statusCode, responseStr);
    [responseStr release];
}


- (void)couchbaseDidStart:(NSURL *)serverURL {
    NSAssert(serverURL != nil, @"Couchbase failed to initialize");
	NSLog(@"CouchDB is Ready, go!");
    self.serverURL = serverURL;
    
    if (!sUnitTesting) {
        [self send: @"GET" toPath: @"/" body: nil];
        [self send: @"PUT" toPath: @"/testdb" body: nil];
        [self send: @"GET" toPath: @"/testdb" body: nil];
        [self send: @"POST" toPath: @"/testdb/" body: @"{\"txt\":\"foobar\"}"];
        [self send: @"PUT" toPath: @"/testdb/doc1" body: @"{\"txt\":\"O HAI\"}"];
        [self send: @"GET" toPath: @"/testdb/doc1" body: nil];
        
        NSLog(@"Everything works!");
        
        [self replicationPerformance];
        [self downloadPerformance];
        [self replicationPerformanceTweets];
        [self downloadPerformanceTweets];
    }
}

- (void) replicationPerformance {
    NSLog(@"Replication performance testing...");
    [self send: @"PUT" toPath: @"/target" body: nil];
    NSDate *date1 = [NSDate date];
    [self send: @"POST" toPath: @"/_replicate" body: 
     @"{\"source\":\"http://10.17.16.88:5984/dhl-filtered\", \"target\":\"target\"}"];
    NSDate *date2 = [NSDate date];
    NSTimeInterval diff = [date2 timeIntervalSinceDate:date1];
    NSLog(@"Pull replication took %lu seconds", (unsigned long)diff);    
}

- (void) downloadPerformance {
    NSLog(@"Downloading equivalent file");
    NSDate *date1 = [NSDate date];
    NSURL* url = [NSURL URLWithString: @"http://10.17.16.88:5984/files/test/dhl-filtered.couch"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL: url];
    request.HTTPMethod = @"GET";
    NSURLResponse* response = nil;
    NSError* error = nil;
    NSData* responseBody = [NSURLConnection sendSynchronousRequest: request
                                                 returningResponse: &response
                                                             error: &error];
    NSAssert(responseBody != nil && response != nil,
             @"Request to <%@> failed: %@", url.absoluteString, error);
    int statusCode = ((NSHTTPURLResponse*)response).statusCode;
    NSAssert(statusCode < 300,
             @"Request to <%@> failed: HTTP error %i", url.absoluteString, statusCode);
    NSLog(@"Writing to disk");
    [responseBody writeToFile: @"filename.couch" atomically:NO];
    NSDate *date2 = [NSDate date];
    NSTimeInterval diff = [date2 timeIntervalSinceDate:date1];
    NSLog(@"Download file took %lu seconds", (unsigned long)diff);
}

- (void) replicationPerformanceTweets {
    NSLog(@"Replication performance testing Tweets...");
    [self send: @"PUT" toPath: @"/target-tweets" body: nil];
    NSDate *date1 = [NSDate date];
    [self send: @"POST" toPath: @"/_replicate" body: 
     @"{\"source\":\"http://10.17.16.88:5984/tweets\", \"target\":\"target-tweets\"}"];
    NSDate *date2 = [NSDate date];
    NSTimeInterval diff = [date2 timeIntervalSinceDate:date1];
    NSLog(@"Pull replication took %lu seconds", (unsigned long)diff);    
}

- (void) downloadPerformanceTweets {
    NSLog(@"Downloading equivalent file Tweets");
    NSDate *date1 = [NSDate date];
    NSURL* url = [NSURL URLWithString: @"http://10.17.16.88:5984/files/test/tweets.couch"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL: url];
    request.HTTPMethod = @"GET";
    NSURLResponse* response = nil;
    NSError* error = nil;
    NSData* responseBody = [NSURLConnection sendSynchronousRequest: request
                                                 returningResponse: &response
                                                             error: &error];
    NSAssert(responseBody != nil && response != nil,
             @"Request to <%@> failed: %@", url.absoluteString, error);
    int statusCode = ((NSHTTPURLResponse*)response).statusCode;
    NSAssert(statusCode < 300,
             @"Request to <%@> failed: HTTP error %i", url.absoluteString, statusCode);
    NSLog(@"Writing to disk");
    [responseBody writeToFile: @"filenametweets.couch" atomically:NO];
    NSDate *date2 = [NSDate date];
    NSTimeInterval diff = [date2 timeIntervalSinceDate:date1];
    NSLog(@"Download file took %lu seconds", (unsigned long)diff);
}

@end
