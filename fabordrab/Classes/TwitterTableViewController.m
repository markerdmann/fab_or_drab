    //
//  TwitterViewController.m
//  Schutt
//
//  Created by Mark Sands on 4/22/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "TwitterTableViewController.h"
#import "TwitterTableViewCell.h"

#define NETWORK_TIMEOUT 120.0
#define TwitterURL @"https://twitter.com/statuses/user_timeline/marksands.json"

#pragma mark -

@interface TwitterTableViewController (Private)
	- (void) parseTweets;

	- (CGFloat) prepareCellLayout:(NSIndexPath*) indexPath;
	- (void) prepareCell:(TwitterTableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath;

	- (NSDate*)dateFromTwitterString:(NSString*)dateString;
	- (NSString*)stringFromTwitterDate:(NSDate*)date;

	- (NSString*)stringFromReplacingEscapeCharactersInString:(NSString*)theText;
@end

@implementation TwitterTableViewController

// --------------------------------------------------------------------------------------------
// --------------------------------------------------------------------------------------------

#pragma mark -
#pragma mark Twitter Loading Methods

/*
 * reloadTableViewDataSource
 * Last Modified: 4May2010
 * - Mark
 *
 * overloaded reload on pull-to-refresh loads all new tweets. 
 * downloads the JSON into the tweetsData buffer.
 *
 */
- (void) reloadTableViewDataSource
{
	if ( tweetsData != nil )
		[tweetsData release];
	tweetsData = [[NSMutableData alloc] init];
	NSURL	*url = [NSURL URLWithString:TwitterURL];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url
																								cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData 
																						timeoutInterval:NETWORK_TIMEOUT];
	[NSURLConnection connectionWithRequest:request delegate:self ];
	[request release];
}

/*
 * connection
 * Last Modified: 24April2010
 * - Mark
 * 
 * appends new JSON data to tweets
 *
 */
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[tweetsData appendData:data];
}

/*
 * connectionDidFinishLoading
 * Last Modified: 24April2010
 * - Mark
 * 
 * stops the activity indicator and parses the tweets
 * 
 */
- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
	[self doneLoadingTableViewData];
	[self parseTweets];
}

/*
 * connection didFailWithError
 * Last Modified: 28April2010
 * - Mark
 * 
 * If the connection fails, calls displayModalAlertWithError
 * which renders a custom UIModalAlert with the error message
 * 
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[self doneLoadingTableViewData];
	//[self displayModalAlertWithError:error];
	
	[tweetsData release];
	tweetsData = nil;
}

#pragma mark -

/*
 * parseTweets
 * Last Modified: 5May2010
 * - Mark
 * 
 * Parses the tweetsData JSON data into an NSMutableArray and grabs the elements from
 * each index
 * 
 */
- (void) parseTweets
{
	NSMutableArray *array = [[CJSONDeserializer deserializer] deserialize:tweetsData error:nil];
	tweetsArray = [[NSMutableArray alloc] init];
	
	for ( id object in array) {
		Tweet *twt = [[Tweet alloc] init];

		NSDate *tweetDate = [self dateFromTwitterString:[object valueForKey:@"created_at"]]; // [self dateFromTwitterString:[object valueForKey:@"created_at"]];
		NSString *tweetText = [object valueForKey:@"text"];
		
		tweetText = [self stringFromReplacingEscapeCharactersInString:tweetText];
		
		[twt setCreated:tweetDate];
		[twt setText:tweetText];
		[tweetsArray addObject:twt];
		[twt release];
	}

	[self.tableView reloadData];	
}

#pragma mark -

/* * *
 * * http://stackoverflow.com/questions/2002544/iphone-twitter-api-converting-time
 * dateFromTwitterString
 * Last Modified: 24April2010
 * - Mark
 * 
 * Parses the created_at string and returns the Date for convenience.
 * see http://unicode.org/reports/tr35/tr35-6.html#Date_Format_Patterns
 *
 */
- (NSDate*)dateFromTwitterString:(NSString*)dateString
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
	[dateFormatter setLocale:usLocale]; 
	[usLocale release];
	[dateFormatter setDateStyle:NSDateFormatterLongStyle];
	[dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
	
	[dateFormatter setDateFormat: @"EEE MMM dd HH:mm:ss +0000 yyyy"];
	
	NSDate *date = [dateFormatter dateFromString:dateString];
	[dateFormatter release];

	return date;
}

/* 
 * stringFromDate
 * Last Modified: 24April2010
 * - Mark
 * 
 * Returns a custom formatted string from a given date
 * 
 */
- (NSString*)stringFromTwitterDate:(NSDate*)date
{
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	[format setDateFormat:@"hh:mm a EEE MMM dd"];
	NSString *dateString = [format stringFromDate:date];
	[format release];
	
	return dateString;
}

/*
 * stringFromReplacingEscapeCharactersInString:(NSString*)theText
 * Last Modified: 28May2010
 * - Mark
 *
 * Returns a proper formatted string by replacing escape characters
 * 
 */
- (NSString*)stringFromReplacingEscapeCharactersInString:(NSString*)theText
{
	/* less than/greater than */
	theText = [theText stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
	theText = [theText stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
	
	// currently it's only breaking on &lt; and &gt;
	
	// test string: " < > € £ ¢ ¥ ® ©	
	
	return theText;
}

// --------------------------------------------------------------------------------------------
// --------------------------------------------------------------------------------------------

#pragma mark -
#pragma mark TableViewController Methods

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
	[super loadView];
	[self setColoredNavigationBarWithTitle:@"Twitter" andColor:[UIColor blackColor]];
}

// calls [self reloadTableViewDataSource] to load the cells
- (void)viewDidLoad
{
	[super viewDidLoad];
	[self loadTableData];
}

// Implement viewWillAppear to do additional setup
- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:YES];
}

// Implement viewDidAppear to do additional setup after launch
- (void) viewDidAppear:(BOOL)animated
{
	[super viewWillAppear:YES];
}

// Releases the view if it doesn't have a superview.
// Release any cached data, images, etc that aren't in use.
- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

// Release any retained subviews of the main view.
// e.g. self.myOutlet = nil;
- (void)viewDidUnload
{
	[super viewDidUnload];
}

// --------------------------------------------------------------------------------------------
// --------------------------------------------------------------------------------------------

#pragma mark -
#pragma mark TableViewController Custom Methods

/*
 * tableView numberOfRowsInSection
 * Last Modified: 24April2010
 * - Mark
 * 
 * Returns the number of tweets, which will be how many rows are in the tableView
 * 
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
  return [tweetsArray count];
}

/*
 * tableView heightForRowAtIndex
 * Last Modified: 24April2010
 * - Mark
 * 
 * Calls TwitterTableViewCell's heightForCellInTable method which does some 
 * background calculation to return the height of the cell
 * 
 */
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
	Tweet *twt = [tweetsArray objectAtIndex:indexPath.row];
	return [TwitterTableViewCell heightForCellInTable:tableView withText:twt.text];
}

/*
 * tableView cellForRowAtIndexPath
 * Last Modified: 24April2010
 * - Mark
 * 
 * Initializes each cell. Calls prepareCell forIndexPath to assign each cell to a
 * tweet from the tweetsArray
 * 
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
  static NSString *CellIdentifier = @"Twitter Cell";

	TwitterTableViewCell *cell = (TwitterTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [TwitterTableViewCell cellWithReuseIdentifier:CellIdentifier];
  }

  [self prepareCell:cell forIndexPath:indexPath];
	
  return cell;
}

/*
 * prepareCell forIndexPath
 * Last Modified: 24April2010
 * - Mark
 * 
 * Sets up each cell with its tweet data
 * http://stackoverflow.com/questions/422066/gradients-on-uiview-and-uilabels-on-iphone/1931498#1931498
 * http://stackoverflow.com/questions/281515/how-to-customize-the-background-color-of-a-uitableviewcell
 * http://cocoawithlove.com/2009/08/adding-shadow-effects-to-uitableview.html
 */
- (void)prepareCell:(TwitterTableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
  Tweet *twt = [tweetsArray objectAtIndex:indexPath.row];
		
	cell.textLabel.text = [self stringFromTwitterDate:twt.created];
	cell.detailTextLabel.text = twt.text;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;	
	
}

/*
 * tableView didSelectRowAtIndex
 * Last Modified: 5May2010
 * - Mark
 * 
 * Pushes the 'share tweet' view controller on the stack, via PeepCode
 * 
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	[super tableView:tableView didSelectRowAtIndexPath:indexPath];
	
	Tweet *twt = [tweetsArray objectAtIndex:indexPath.row];
	RetweetViewController *next = [[RetweetViewController alloc] initWithTweet:twt];
	[self.navigationController pushViewController:next animated:YES];
	[next release];
}

- (void)dealloc
{
    [super dealloc];
}

@end