//
//  RootViewController.m
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

#import "RootViewController.h"
#import "CCouchDBServer.h"
#import "CCouchDBDatabase.h"
#import "NewItemViewController.h"
#import "DatabaseManager.h"

@implementation RootViewController
@synthesize items;
@synthesize syncItem;
@synthesize activityButtonItem;

#pragma mark -
#pragma mark View lifecycle


-(void)couchbaseDidStart
{
	[self loadItemsIntoView];
	
	self.syncItem = [[[UIBarButtonItem alloc] 
					  initWithTitle:@"Sync" style:UIBarButtonItemStyleBordered
					  target:self 
					  action:@selector(sync) 
					  ] autorelease];
	self.navigationItem.rightBarButtonItem = self.syncItem;
	self.navigationItem.leftBarButtonItem.enabled = YES;
	self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;

	// setup buttons
	UIBarButtonItem *addButtonItem = [[[UIBarButtonItem alloc] 
									   initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
										   target:self 
										   action:@selector(addItem) 
									 ] autorelease];
	addButtonItem.enabled = NO;
	self.navigationItem.leftBarButtonItem = addButtonItem;

	UIActivityIndicatorView *activity = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
	[activity startAnimating];
	self.activityButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:activity] autorelease];
	self.activityButtonItem.enabled = NO;
	self.navigationItem.rightBarButtonItem = activityButtonItem;
}

-(void)sync
{
	self.syncItem = self.navigationItem.rightBarButtonItem;
	[self.navigationItem setRightBarButtonItem: self.activityButtonItem animated:YES];
	DatabaseManager *manager = [DatabaseManager sharedManager];
	DatabaseManagerSuccessHandler successHandler = ^() {
  	    //woot	
		NSLog(@"success handler called!");
		[self loadItemsIntoView];
	};

	DatabaseManagerErrorHandler errorHandler = ^(id error) {
		// doh	
	};
	
	[manager syncFrom:@"http://jan.couchone.com/demo" to:@"demo" onSuccess:successHandler onError:errorHandler];
	[manager syncFrom:@"demo" to:@"http://jan.couchone.com/demo" onSuccess:^() {} onError:^(id error) {}];
}

-(void)loadItemsIntoView
{
	if(self.navigationItem.rightBarButtonItem != syncItem) {
		[self.navigationItem setRightBarButtonItem: syncItem animated:YES];
	}

	DatabaseManager *sharedManager = [DatabaseManager sharedManager];
	CouchDBSuccessHandler inSuccessHandler = ^(id inParameter) {
		NSLog(@"RVC Wooohooo! %@: %@", [inParameter class], inParameter);
		self.items = inParameter;
		[self.tableView reloadData];
	};
	
	CouchDBFailureHandler inFailureHandler = ^(NSError *error) {
		NSLog(@"RVC D'OH! %@", error);
	};
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:@"true", @"descending", @"true", @"include_docs", nil];
	CURLOperation *op = [sharedManager.database operationToFetchAllDocumentsWithOptions:options 
																	 withSuccessHandler:inSuccessHandler 
																		 failureHandler:inFailureHandler];
	[op start];
}	

-(void)newItemAdded
{
	[self loadItemsIntoView];
	[self dismissModalViewControllerAnimated:YES];
}

-(void)addItem
{
	// TBD
	NewItemViewController *newItemVC = [[NewItemViewController alloc] initWithNibName:@"NewItemViewController" bundle:nil];
	newItemVC.delegate = self;
	UINavigationController *newItemNC = [[UINavigationController alloc] initWithRootViewController:newItemVC];
	[self presentModalViewController:newItemNC animated:YES];
	[newItemVC release];
	[newItemNC release];
}
									  

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
	CCouchDBDocument *doc = [self.items objectAtIndex:indexPath.row];
	cell.textLabel.text = [[doc valueForKey:@"content"] valueForKey:@"text"];
    return cell;
}


// Override to support conditional editing of the table view.
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
		NSUInteger position = [indexPath indexAtPosition:1]; // indexPath is [0, idx]
		[[DatabaseManager sharedManager] deleteDocument: [items objectAtIndex:position]];
		[items removeObjectAtIndex: position];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}



/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

