//
//  RootViewController.h
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

#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController {
	NSMutableArray *items;
	UIBarButtonItem *syncItem;
	UIBarButtonItem *activityButtonItem;
}
@property(nonatomic, retain)NSMutableArray *items;
@property(nonatomic, retain)UIBarButtonItem *syncItem;
@property(nonatomic, retain)UIBarButtonItem *activityButtonItem;

-(void)loadItemsIntoView;
-(void)couchbaseDidStart;

@end
