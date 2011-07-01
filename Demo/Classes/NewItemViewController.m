//
//  NewItemViewController.m
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

#import "NewItemViewController.h"
#import "CCouchDBDatabase.h"
#import "CouchDBClientTypes.h"
#import "DatabaseManager.h"
#import "RootViewController.h"
#import "CURLOperation.h"

@implementation NewItemViewController
@synthesize textView;
@synthesize delegate;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	UIBarButtonItem *doneButtonItem = [[[UIBarButtonItem alloc]
								initWithBarButtonSystemItem:UIBarButtonSystemItemSave
									   target:self 
									   action:@selector(done) 
									   ] autorelease];
	self.navigationItem.rightBarButtonItem = doneButtonItem;

	UIBarButtonItem *cancelButtonItem = [[[UIBarButtonItem alloc]
										initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
										target:self
										action:@selector(cancel)
										] autorelease];
	self.navigationItem.leftBarButtonItem = cancelButtonItem;
}

-(void)cancel
{
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

-(void)done
{
	NSString *text = textView.text;
	
	NSDictionary *inDocument = [NSDictionary dictionaryWithObjectsAndKeys:text, @"text"
                                , [[NSDate date] description], @"created_at"
                                , nil];
	CouchDBSuccessHandler inSuccessHandler = ^(id inParameter) {
		NSLog(@"Wooohooo! %@", inParameter);
		[delegate performSelector:@selector(newItemAdded)];
	};
	
	CouchDBFailureHandler inFailureHandler = ^(NSError *error) {
		NSLog(@"D'OH! %@", error);
	};
	CFUUIDRef uuid = CFUUIDCreate(nil);
    NSString *guid = (NSString*)CFUUIDCreateString(nil, uuid);
    CFRelease(uuid);
	NSString *docId = [NSString stringWithFormat:@"%f-%@", CFAbsoluteTimeGetCurrent(), guid];
	DatabaseManager *sharedManager = [DatabaseManager sharedManager:[delegate getCouchbaseURL]];
	CURLOperation *op = [sharedManager.database operationToCreateDocument:inDocument 
															   identifier:docId
														   successHandler:inSuccessHandler 
														   failureHandler:inFailureHandler];
	[op start];
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[textView becomeFirstResponder];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
