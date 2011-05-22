//
//  DocumentManager.m
//  Couchbase Mobile
//
//  Created by Jan Lehnardt on 27/11/2010.
//  Copyright 2011 Couchbase, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may not
// use this file except in compliance with the License. You may obtain a copy of
// the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
// WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
// License for the specific language governing permissions and limitations under
// the License.
//

#import "DatabaseManager.h"
#import "CCouchDBServer.h"
#import "CCouchDBDatabase.h"
#import "CURLOperation.h"

#define DATABASE_NAME @"demo"

static DatabaseManager *sharedManager;

@implementation DatabaseManager

@synthesize database;
@synthesize delegate;
@synthesize connections;

+(DatabaseManager *)sharedManager:(NSURL *)dbURL
{
	if(sharedManager == nil) {
		sharedManager = [[DatabaseManager alloc] init: dbURL];
	}
	return sharedManager;
}

-(id)init:(NSURL *)dbURL
{
	[super init];
	server = [[CCouchDBServer alloc] initWithSession:NULL URL:dbURL];
	database = [[server databaseNamed:DATABASE_NAME] retain];
	connections = [[NSMutableDictionary alloc] init];
	return self;
}


-(void)doSyncFrom:(NSString *)from to:(NSString *)to onSuccess:(DatabaseManagerSuccessHandler)success onError:(DatabaseManagerErrorHandler) error
{
	NSURL *theUrl = [server.URL URLByAppendingPathComponent:@"_replicate"];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theUrl];
	theRequest.HTTPMethod = @"POST";
	[theRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	NSString *body = [NSString stringWithFormat:@"{\"source\":\"%@\",\"target\":\"%@\"}", from, to];
	[theRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
	NSDictionary *callbacks = [[NSDictionary dictionaryWithObjectsAndKeys:[success copy], @"success", [error copy], @"error", nil] retain];
	NSURLConnection *connection = [[NSURLConnection connectionWithRequest:theRequest delegate:self] retain];
	[connections setObject:callbacks forKey:[connection description]];
}	

-(void)syncFrom:(NSString *)from to:(NSString *)to onSuccess:(DatabaseManagerSuccessHandler)success onError:(DatabaseManagerErrorHandler) error
{
	[self doSyncFrom:from to:to onSuccess:success onError:error];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSLog(@"Sync Error: %@", error);
	id callbacks = [connections objectForKey:[connection description]];
	if(callbacks != nil) {
		DatabaseManagerErrorHandler errorHandler = [callbacks valueForKey:@"error"];
		if(errorHandler) {
  		    errorHandler(error);
		    [errorHandler release];
		}
	}
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	id callbacks = [connections valueForKey:[connection description]];
	if(callbacks != nil) {
		DatabaseManagerSuccessHandler successHandler = [callbacks valueForKey:@"success"];
		NSLog(@"got my success handler");
		if(successHandler) {
  		    successHandler();
			[successHandler release];
		}
	}
}

-(void)deleteDocument:(CCouchDBDocument *)inDocument
{
	CouchDBSuccessHandler inSuccessHandler = ^(id inParameter) {
		NSLog(@"Wooohooo! Deleted %@", inParameter);
	};

	CouchDBFailureHandler inFailureHandler = ^(NSError *error) {
		NSLog(@"D'OH! No Delete %@", error);
	};
	CURLOperation *op = [self.database operationToDeleteDocument: inDocument
							  successHandler:inSuccessHandler
							  failureHandler:inFailureHandler];
	[op start];
}

-(void)dealloc
{
	[server release];
	[connections release];
    [super dealloc];
}
@end
