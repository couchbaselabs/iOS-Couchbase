//
//  Couchbase.h
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


#import <Foundation/Foundation.h>

@protocol CouchbaseDelegate
@required
-(void)couchbaseDidStart:(NSURL *)serverURL;
@end


/** Manages an embedded instance of CouchDB that runs in a background thread. */
@interface CouchbaseEmbeddedServer : NSObject
{
    id<CouchbaseDelegate> _delegate;
    CFAbsoluteTime _timeStarted;
    NSString* _documentsDirectory;
    NSString* _bundlePath;
    NSURL* _serverURL;
    NSError* _error;
    pthread_t _erlangThread;
}

/** Convenience to instantiate and start a new instance. */
+ (CouchbaseEmbeddedServer*) startCouchbase: (id<CouchbaseDelegate>)delegate;

/** Initializes the instance. */
- (id) init;

/** Initializes the instance with a nonstandard location for the runtime resources.
    (The default location is Resources/CouchbaseResources, but some application frameworks
    require resources to go elsewhere, so in that case you might need to use a custom path.) */
- (id) initWithBundlePath: (NSString*)bundlePath;

/** The delegate object, which will be notified when the server starts. */
@property (assign) id<CouchbaseDelegate> delegate;

/** The directory where CouchDB writes its log files. */
@property (readonly) NSString* logDirectory;

/** The directory where CouchDB stores its database files. */
@property (readonly) NSString* databaseDirectory;

/** Copies a database file into the databaseDirectory if no such file exists there already.
    Call this before -start, to set up initial contents of one or more databases on first run. */
- (BOOL) installDefaultDatabase: (NSString*)databasePath;

/** Starts the server, asynchronously. The delegate will be called when it's ready.
    @return  YES if the server is starting, NO if it failed to start. */
- (BOOL) start;

/** The HTTP URL the server is listening on.
    Will be nil until the server has finished starting up, some time after -start is called.
    This property is KV-observable, so an alternative to setting a delegate is to observe this property and wait for it to change to non-nil (although this will not detect if the server fails to start up.) */
@property (readonly, retain) NSURL* serverURL;

/** If the server fails to start up, this will be set to a description of the error. */
@property (readonly, retain) NSError* error;

@end
