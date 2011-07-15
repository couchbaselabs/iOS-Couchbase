//
//  EmptyAppDelegate.h
//  Couchbase Empty App
//
//  Created by Jens Alfke on 7/8/11.
//  Copyright 2011 Couchbase, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Couchbase/CouchbaseEmbeddedServer.h>

@interface EmptyAppDelegate : UIResponder <UIApplicationDelegate, CouchbaseDelegate>

@property (retain, nonatomic) UIWindow *window;

@property (retain, nonatomic) NSURL* serverURL;

@end
