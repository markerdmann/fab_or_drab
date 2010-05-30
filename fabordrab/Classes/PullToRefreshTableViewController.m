//
//  PullToRefreshTableViewController.m
//  Schutt
//
//  Created by Mark Sands on 4/24/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "PullToRefreshTableViewController.h"

@interface PullToRefreshTableViewController	(Private)
- (void)dataSourceDidFinishLoadingNewData;
@end

@implementation PullToRefreshTableViewController

@synthesize reloading = _reloading;

- (void) viewDidLoad
{
	[super viewDidLoad];

	if (refreshHeaderView == nil) {
		refreshHeaderView = [[RefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, 320.0f, self.tableView.bounds.size.height)];
		refreshHeaderView.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
		[self.tableView addSubview:refreshHeaderView];
		self.tableView.showsVerticalScrollIndicator = YES;
		[refreshHeaderView release];
	}
	
	/* - future implementation -
	 *  
	 *  SoundEffect = [[Balto alloc] initWithFiles:[NSArray arrayWithObjects:
	 * 																											[[NSBundle mainBundle] pathForResource:@"psst1" ofType:@"wav"]
	 * 																											[[NSBundle mainBundle] pathForResource:@"psst2" ofType:@"wav"]
	 * 																											[[NSBundle mainBundle] pathForResource:@"pop"   ofType:@"wav"]]]
	 *  
   *	psst1Sound = [[SoundEffect alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"psst1" ofType:@"wav"]];
   *	psst2Sound  = [[SoundEffect alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"psst2" ofType:@"wav"]];
   *	popSound  = [[SoundEffect alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pop" ofType:@"wav"]];
	 *  
	 */
}

- (void) dealloc
{
	/* - future implementation -
	 *
	 * [SoundEffet release];
	 * [psst1Sound release];
	 * [psst2Sound release];
	 * [popSound release];
	 */
	
	refreshHeaderView = nil;
	[super dealloc];
}

#pragma mark State Changes

- (void)dataSourceDidFinishLoadingNewData
{	
	_reloading = NO;

	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[self.tableView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];

	[refreshHeaderView setState:PullRefreshNormal];
	[refreshHeaderView setCurrentDate];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
	// Configure the cell.
	
	return cell;
}

/* Should be calling model's reload */
- (void)reloadTableViewDataSource
{
	NSLog(@"Please override reloadTableViewDataSource");
}

/* model should call this when its done loading */
- (void)doneLoadingTableViewData
{
	[self dataSourceDidFinishLoadingNewData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark Scrolling Overrides
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	if (!_reloading) {
		checkForRefresh = YES;  //  only check offset when dragging
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{	 
 if (scrollView.isDragging)
 {
	 if (refreshHeaderView.state == PullRefreshPulling && scrollView.contentOffset.y > -70.0f && scrollView.contentOffset.y < 0.0f && !_reloading) {
		 [refreshHeaderView setState:PullRefreshNormal];
		 /* [popSound play]; */
	 }
	 else if (refreshHeaderView.state == PullRefreshNormal && scrollView.contentOffset.y < -70.0f && !_reloading) {
		 [refreshHeaderView setState:PullRefreshPulling];
		 /* [psst1Sound play]; */
	 }
 }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{ 
 if (scrollView.contentOffset.y <= - 70.0f && !_reloading)
 {
	 [self loadTableData];
 }
}

// convenience public method for initialization
- (void) loadTableData
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	_reloading = YES;
	[self reloadTableViewDataSource];
	[refreshHeaderView setState:PullRefreshLoading];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.2];
	self.tableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
	[UIView commitAnimations];	
}

@end