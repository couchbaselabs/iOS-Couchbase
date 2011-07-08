//
//  Couchbase_Empty_AppAppDelegate.h
//  Couchbase Empty App
//
//  Created by Jens Alfke on 7/8/11.
//  Copyright 2011 Couchbase, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Couchbase/Couchbase.h>

@interface Couchbase_Empty_AppAppDelegate : UIResponder <UIApplicationDelegate, CouchbaseDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (retain) NSURL* serverURL;

@end
