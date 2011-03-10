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
	sprintf(inipath2, "%s/icouch.ini", (char*) data);
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
	NSString* myPath = [mainBundle pathForResource:@"MobileCouchbase" ofType:@"bundle"];
	char app_root[1024];
	char erl_root[1024];
	char bindir[1024];
	
	strncpy(app_root, [myPath UTF8String], 1024);
	sprintf(erl_root, "%s/erlang", app_root);
	sprintf(bindir, "%s/erts-5.7.5/bin", erl_root);
	
	NSString *focusPath = @"/demo.couch";
	NSString *iniPath = @"/icouch.ini";
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *logDir = [documentsDirectory stringByAppendingString:@"/log"];
	NSString *dataDir = [documentsDirectory stringByAppendingString:@"/couchdb"];
	
	NSString *focusSource = [myPath stringByAppendingString:focusPath];	
	NSString *focusTarget = [dataDir stringByAppendingString:focusPath];
	
	NSString *iniSource = [myPath stringByAppendingString:iniPath];	
	NSString *iniTarget = [documentsDirectory stringByAppendingString:iniPath];
	
	NSFileManager *NSFm= [NSFileManager defaultManager]; 
	BOOL isDir=YES;
	
	NSError *copyError = nil;
	
	if(![NSFm fileExistsAtPath:logDir isDirectory:&isDir])
		if(![NSFm createDirectoryAtPath:logDir withIntermediateDirectories:YES attributes:nil error:NULL])
			NSLog(@"Error: Create folder failed");
	if(![NSFm fileExistsAtPath:dataDir isDirectory:&isDir])
		if(![NSFm createDirectoryAtPath:dataDir withIntermediateDirectories:YES attributes:nil error:NULL])
			NSLog(@"Error: Create folder failed");
	
	// Copy Initial focus DB + ini file on first load
	if(![NSFm fileExistsAtPath:focusTarget]) {
		[NSFm copyItemAtPath:focusSource toPath:focusTarget error:&copyError];
	}	
	if(![NSFm fileExistsAtPath:iniTarget]) {
		[NSFm copyItemAtPath:iniSource toPath:iniTarget error:&copyError];
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

	NSThread *waiterThread = [[NSThread alloc] initWithTarget:self
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
	return connect(sockfd,(struct sockaddr*) &addr, sizeof(addr));
}

+ (void)waitForCouchDB {
	while ([self connectToHost:"0.0.0.0" port:5984]) {
		sleep(1);
	}
	sleep(1);
}

+ (void)waitAndNotifyMainThread:(NSObject*)delegate
{
	[self waitForCouchDB];
	[delegate performSelectorOnMainThread:@selector(couchbaseDidStart)
							   withObject:nil
							waitUntilDone:NO];
}

@end
