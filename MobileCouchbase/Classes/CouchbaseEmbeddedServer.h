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
    NSString* _iniFilePath;
    NSURL* _serverURL;
    NSError* _error;
    pthread_t _erlangThread;
}

/** Convenience to instantiate and start a new instance. */
+ (CouchbaseEmbeddedServer*) startCouchbase: (id<CouchbaseDelegate>)delegate;

/** Initializes the instance. */
- (id) init;

/** The delegate object, which will be notified when the server starts. */
@property (assign) id<CouchbaseDelegate> delegate;

/** Starts the server, asynchronously. The delegate will be called when it's ready.
    @return  YES if the server is starting, NO if it failed to start. */
- (BOOL) start;

/** The HTTP URL the server is listening on.
    Will be nil until the server has finished starting up, some time after -start is called.
    This property is KV-observable, so an alternative to setting a delegate is to observe this
    property and the -error property and wait for one of them to become non-nil. */
@property (readonly, retain) NSURL* serverURL;

/** If the server fails to start up, this will be set to a description of the error.
    This is KV-observable. */
@property (readonly, retain) NSError* error;

#pragma mark CONFIGURATION:

/** Initializes the instance with a nonstandard location for the runtime resources.
    (The default location is Resources/CouchbaseResources, but some application frameworks
    require resources to go elsewhere, so in that case you might need to use a custom path.) */
- (id) initWithBundlePath: (NSString*)bundlePath;

/** The directory where CouchDB writes its log files. */
@property (readonly) NSString* logDirectory;

/** The directory where CouchDB stores its database files. */
@property (readonly) NSString* databaseDirectory;

/** The path to an app-specific CouchDB configuration (".ini") file.
    Optional; defaults to nil.
    The settings in this file will override the default CouchDB settings in default.ini, but
    will in turn be overridden by any locally-made settings (see -localIniFilePath). */
@property (copy) NSString* iniFilePath;

/** The path to the mutable local configuration file.
    This starts out empty, but will be modified if the app sends PUT requests to the server's
    _config URI. The app can restore the default configuration at launch by deleting or
    emptying the file at this path before calling -start.*/
@property (readonly) NSString* localIniFilePath;

/** Copies a database file into the databaseDirectory if no such file exists there already.
    Call this before -start, to set up initial contents of one or more databases on first run. */
- (BOOL) installDefaultDatabase: (NSString*)databasePath;

@end
