//
//  main.m
//  Couchbase Empty App
//
//  Created by Jens Alfke on 7/8/11.
//  Copyright 2011 Couchbase, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EmptyAppDelegate.h"

int main(int argc, char *argv[])
{
    NSAutoreleasePool* pool = [NSAutoreleasePool new];
    int retVal = UIApplicationMain(argc, argv, nil,
                                   NSStringFromClass([EmptyAppDelegate class]));
    [pool drain];
    return retVal;
}
