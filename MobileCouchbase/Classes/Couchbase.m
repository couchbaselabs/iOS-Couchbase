//
//  Couchbase.m
//  Couchbase Mobile
//
//  Created by J Chris Anderson on 3/2/11.
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

#import "Couchbase.h"

#include <pthread.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netdb.h>

void erl_start(int, char**);

void* erlang_thread(void* data) {
	char inipath[1024];
	char inipath2[1024];
	char erl_root[1024];
	char erl_inetrc[1024];
	sprintf(erl_root, "%s/erlang", (char*) data);
	sprintf(erl_inetrc, "%s/erlang/erl_inetrc", (char*) data);
	setenv("ERL_INETRC", erl_inetrc, 1);
	sprintf(inipath, "%s/default.ini", (char*) data);
	sprintf(inipath2, "%s/../../Documents/icouch.ini", (char*) data);
	char* erlang_args[] = {"beam", "--", "-noinput", 
		"-eval", "application:start(couch).",
		"-root", erl_root, "-couch_ini",
		inipath, inipath2};

	erl_start(10, erlang_args);
	return NULL;
}

@implementation Couchbase

+ (void)startCouchbase:(id<CouchbaseDelegate>)delegate {
	NSLog(@"Starting the Couch");
	NSBundle* mainBundle;
	mainBundle = [NSBundle mainBundle];
	NSString* myPath = [mainBundle pathForResource:@"Couchbase" ofType:@"bundle"];
	NSLog(@"my bundle path: %@", myPath);

	char app_root[1024];
	char erl_root[1024];
	char bindir[1024];
	
	strncpy(app_root, [myPath UTF8String], 1024);
	sprintf(erl_root, "%s/erlang", app_root);
	sprintf(bindir, "%s/erts-5.7.5/bin", erl_root);
		
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *logDir = [documentsDirectory stringByAppendingString:@"/log"];
	NSString *dataDir = [documentsDirectory stringByAppendingString:@"/couchdb"];

	NSFileManager *NSFm= [NSFileManager defaultManager]; 
	BOOL isDir=YES;
	
	
	if(![NSFm fileExistsAtPath:logDir isDirectory:&isDir])
		if(![NSFm createDirectoryAtPath:logDir withIntermediateDirectories:YES attributes:nil error:NULL])
			NSLog(@"Error: Create folder failed");
	if(![NSFm fileExistsAtPath:dataDir isDirectory:&isDir])
		if(![NSFm createDirectoryAtPath:dataDir withIntermediateDirectories:YES attributes:nil error:NULL])
			NSLog(@"Error: Create folder failed");
	
    NSString *focusPath = @"/demo.couch"; // make this generic
	NSString *focusSource = [myPath stringByAppendingString:focusPath];	
	NSString *focusTarget = [dataDir stringByAppendingString:focusPath];
	NSError *copyError = nil;

	// Copy Initial DB on first load
	if(![NSFm fileExistsAtPath:focusTarget]) {
		[NSFm copyItemAtPath:focusSource toPath:focusTarget error:&copyError];
	}
    if (copyError) {
        NSLog(@"copyError demo.couch %@", copyError);
    }
    copyError = nil;
    NSString *configPath = @"/icouch.ini"; // local config
	NSString *configSource = [myPath stringByAppendingString:configPath];	
	NSString *configTarget = [documentsDirectory stringByAppendingString:configPath];
    
	// Copy Initial DB on first load
	if(![NSFm fileExistsAtPath:configTarget]) {
		[NSFm copyItemAtPath:configSource toPath:configTarget error:&copyError];
	}
    if (copyError) {
        NSLog(@"copyError icouch %@", copyError);
    }
    copyError = nil;
    // emonk view server files
	NSString *emonkMrSource = [myPath stringByAppendingString:@"/erlang/emonk_mapred.js"];
	NSString *emonkMrTarget = [documentsDirectory stringByAppendingString:@"/emonk_mapred.js"];
    
	if(![NSFm fileExistsAtPath:emonkMrTarget]) {
		[NSFm copyItemAtPath:emonkMrSource toPath:emonkMrTarget error:&copyError];
	}
    if (copyError) {
        NSLog(@"copyError emonkApp %@", copyError);
    }
    copyError = nil;
	NSString *emonkAppSource = [myPath stringByAppendingString:@"/erlang/emonk_app.js"];	
	NSString *emonkAppTarget = [documentsDirectory stringByAppendingString:@"/emonk_app.js"];
    
	if(![NSFm fileExistsAtPath:emonkAppTarget]) {
		[NSFm copyItemAtPath:emonkAppSource toPath:emonkAppTarget error:&copyError];
	}
    if (copyError) {
        NSLog(@"maybe copyError emonkApp %@", copyError);
    }

    
    
	// delete the URI file
	NSString *uriPath = [documentsDirectory stringByAppendingString:@"/couch.uri"];
	NSError *removeError = nil;

	if([NSFm fileExistsAtPath:uriPath]) {
		[NSFm removeItemAtPath:uriPath error:&removeError];
        if (removeError) {
            NSLog(@"removed uri file %@", removeError);
        }
	}
	
	[NSFm changeCurrentDirectoryPath: documentsDirectory];
	
	setenv("BINDIR", bindir, 1);
	setenv("ROOTDIR", erl_root, 1);
	setenv("HOME", app_root, 1);
    pthread_t erlThreadID;
	pthread_attr_t erlThreadAttr;
	assert(!pthread_attr_init(&erlThreadAttr));
	assert(!pthread_attr_setdetachstate(&erlThreadAttr, PTHREAD_CREATE_DETACHED));
	
	pthread_create(&erlThreadID, &erlThreadAttr, &erlang_thread, app_root);

	NSThread *waiterThread = [[NSThread alloc] initWithTarget:self // need to pass URL
													 selector:@selector(waitAndNotifyMainThread:)
													   object:delegate];
	[waiterThread start];
}

+ (int)connectToHost:(char*)host port:(int) port {
	struct sockaddr_in addr;
	int sockfd;
	sockfd = socket(AF_INET,SOCK_STREAM, 0);
	addr.sin_family= AF_INET;
	struct hostent *he = gethostbyname(host);
	struct in_addr **list = (struct in_addr **)he->h_addr_list;
	addr.sin_addr = *list[0];
	addr.sin_port = htons(port);
	int result = connect(sockfd,(struct sockaddr*) &addr, sizeof(addr));
	return result;
}

+ (NSURL *)waitForCouchDB {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *uriPath = [documentsDirectory stringByAppendingString:@"/couch.uri"];
	NSFileManager *NSFm= [[NSFileManager alloc] init];
	while(![NSFm fileExistsAtPath:uriPath]) {
		usleep(250000);
	}
	usleep(100000);	
	NSString *rawUriString = [NSString stringWithContentsOfFile:uriPath encoding:NSASCIIStringEncoding error:NULL];
	NSArray *components = [rawUriString componentsSeparatedByString:@"\n"];
	NSString *uriString = [components objectAtIndex:0];

	NSURL *myurl = [NSURL URLWithString:uriString];

	NSNumber *portnum = [myurl port];
	NSString *hoststring = [myurl host];

	int bufferSize = [hoststring lengthOfBytesUsingEncoding: NSASCIIStringEncoding] + 1;
	char hostname[bufferSize];
	[hoststring getCString: hostname maxLength:bufferSize encoding: NSASCIIStringEncoding];

	while ([self connectToHost:hostname port:[portnum intValue]]) {
		usleep(2500);
	}
	usleep(250000);
	return myurl;
}

+ (void)waitAndNotifyMainThread:(NSObject*)delegate
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSURL *serverURL = [self waitForCouchDB];
	if ([delegate respondsToSelector:@selector(couchbaseDidStart:)]) {
	[delegate performSelectorOnMainThread:@selector(couchbaseDidStart:)
								   withObject:serverURL
								waitUntilDone:NO];
	}
	[pool release];
}

@end
