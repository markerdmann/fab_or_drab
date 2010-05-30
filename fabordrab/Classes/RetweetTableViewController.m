//
//  RetweetViewController.m
//  Schutt
//
//  Created by Mark Sands on 5/6/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "RetweetTableViewController.h"

@interface RetweetViewController (PrivateMethods)

- (void)prepareCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath;
- (NSString*)stringFromTwitterDate:(NSDate*)date;
- (NSString *)linkableText:(NSString *)text;

@end

@implementation RetweetViewController

@synthesize tweet;

#pragma mark -
#pragma mark Loading

/* 
 * initWithTweet
 * LastModified: 6May2010
 * - Mark
 * 
 * Initializes the Retweet view controller, sets self.tweet to the passed value
 * which gives it the tweet information it needs to be... retweeted
 * Adds a custom back button view onto the navbar.
 *
 */
- (id)initWithTweet:(Tweet *)twt
{
  if ( self = [super initWithStyle:UITableViewStyleGrouped] )
	{
		self.tweet = twt;
		[self setColoredNavigationBarWithTitle:@"Retweet" andColor:[UIColor blackColor]];
	}

	return self;
}

/* 
 * viewDidLoad
 * super viewDidLoad
 */
- (void)viewDidLoad
{
  [super viewDidLoad];
}

/*
 * Releases the view if it doesn't have a superview.
 * Release any cached data, images, etc that aren't in use.
 */
- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

/*
 * Release any retained subviews of the main view.
 */
- (void)viewDidUnload
{
	[super viewDidUnload];
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

#pragma mark -
#pragma mark Table view methods

//

#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if ( section == 1 )
		return 2;
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	if ( section == 0 )
		return 75;
	else
		return 0;
}

/* 
 * tableView viewForHeaderInSection
 * Last Modified: 7May2010
 * - Mark
 * 
 * Creates a custom Header in both sections:
 * 
 * - In section 1, the header view is the @SchuttSports logo/name
 * 
 * - In section 2, the header view is a huge UITextView created in order
 *   to allow selectable text from the tweet. Custom labels are positioned for style
 * 
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	if ( section == 0 )
	{	
		CGRect headerFrame	 = CGRectMake(0, 0, 320, 65);
		CGRect imageFrame		 = CGRectMake(10, 10, 50, 50);
		CGRect nameFrame		 = CGRectMake(70, 10, 320, 30);
		CGRect usernameFrame = CGRectMake(70, 30, 320, 30);
		CGRect gradientFrame = CGRectMake(0, 65, 320, 10);
		CGSize imageSize     = CGSizeMake(60, 60);
		
		NSArray *gradArray   = [NSArray arrayWithObjects:
														(id)[[UIColor clearColor] CGColor], 
														(id)[[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1] CGColor], nil];
		
		UIView *hugeView				= [[[UIView alloc] initWithFrame:headerFrame] autorelease];
		
		UIImageView *imageView  = [[UIImageView alloc] initWithFrame:imageFrame];
		imageView.image					= [UIImage imageNamed:@"icon.png" scaledToSize:imageSize];
		CALayer *rounded = [imageView layer];
		rounded.masksToBounds   = YES;
		rounded.cornerRadius    = 6.0;	

		UILabel *name      = [[[UILabel alloc] initWithFrame:nameFrame] autorelease];
		name.backgroundColor = [UIColor clearColor];
		name.text					 = @"Fab or Drab";
		name.font					 = [UIFont boldSystemFontOfSize:16.0f];
		name.textColor		 = [UIColor blackColor];
		
		UILabel *username  = [[[UILabel alloc] initWithFrame:usernameFrame] autorelease];
		username.backgroundColor = [UIColor clearColor];
		username.text      = @"@FabOrDrab";
		username.font      = [UIFont fontWithName:@"Verdana" size:12.0f];
		username.textColor = [UIColor blackColor];
		
		CAGradientLayer *gradient = [CAGradientLayer layer];
		gradient.frame						= gradientFrame;
		gradient.colors						= gradArray;
						
		[hugeView addSubview:imageView];
		[hugeView addSubview:name];
		[hugeView	addSubview:username];
		[hugeView.layer insertSublayer:gradient atIndex:0];

		return hugeView;
	}
	else
		return nil;
}

//

#pragma mark -

/*
 * tableView heightForRowAtIndex
 * Last Modified: 8May2010
 * - Mark
 * 
 * Calls TwitterTableViewCell's heightForCellInTable method which does some 
 * background calculation to return the height of the cell
 * 
 */
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
	if ( indexPath.section == 0 )
	{
		CGSize frameSize		= [tweet.text sizeWithFont:[UIFont fontWithName:@"Verdana" size:14.0f] 
															 constrainedToSize:CGSizeMake(300, FLT_MAX)
																	 lineBreakMode:UILineBreakModeWordWrap];
		CGFloat frameHeight = frameSize.height + 2.0f * 10.0f;
		return frameHeight + 25;
	}
	else
		return 44.0f;
}

/*
 * tableView cellForRowAtIndexPath
 * Last Modified: 8May2010
 * - Mark
 * 
 * Initializes each cell. Calls prepareCell forIndexPath to assign each cell to a
 * tweet from the tweetsArray
 * 
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
  static NSString *CellIdentifier = @"Twitter Cell";
	static NSString *TweetIdentifier = @"Retweet Cell";
	
	if ( indexPath.section == 0 ) {
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
		}	
		
		[self prepareCell:cell forIndexPath:indexPath];

		cell.selectionStyle = UITableViewCellSelectionStyleNone;

		return cell;
	}
	else {
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TweetIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TweetIdentifier] autorelease];
		}	
		
		[self prepareCell:cell forIndexPath:indexPath];
		
		return cell;			
	}	
}

/*
 * prepareCell forIndexPath
 * Last Modified: 8May2010
 * - Mark
 * 
 * Sets up each cell with its tweet data
 * http://stackoverflow.com/questions/422066/gradients-on-uiview-and-uilabels-on-iphone/1931498#1931498
 * http://stackoverflow.com/questions/281515/how-to-customize-the-background-color-of-a-uitableviewcell
 * http://cocoawithlove.com/2009/08/adding-shadow-effects-to-uitableview.html
 */
- (void)prepareCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{	
	if ( indexPath.section == 0 )
	{
		CGSize frameSize		= [tweet.text sizeWithFont:[UIFont fontWithName:@"Verdana" size:14.0f] 
															 constrainedToSize:CGSizeMake(300, FLT_MAX)
																	 lineBreakMode:UILineBreakModeWordWrap];
		CGFloat frameHeight = frameSize.height + 2.0f * 10.0f;

		CGRect headerFrame	 = CGRectMake(0, 0, 320, frameHeight + 30);
		CGRect tweetFrame    = CGRectMake(0, 0, 320, frameHeight);
		CGRect dateFrame		 = CGRectMake(10, frameHeight, 320, 20);
		CGRect gradientFrame = CGRectMake(0, frameHeight + 30, 320, 10);
		
		NSArray *gradArray   = [NSArray arrayWithObjects:
														(id)[[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1] CGColor],
														(id)[[UIColor clearColor] CGColor], nil]; 
		
		UIView *hugeView		 = [[[UIView alloc] initWithFrame:headerFrame] autorelease];
		hugeView.backgroundColor = [UIColor whiteColor];
		
		UITextView *textField = [[UITextView alloc] initWithFrame:tweetFrame];
		textField.backgroundColor = [UIColor clearColor];
		textField.font = [UIFont fontWithName:@"Verdana" size:14.0f];
		textField.text = tweet.text;
		textField.scrollEnabled = NO;
		textField.editable = NO;

		UILabel *dateLabel  = [[[UILabel alloc] initWithFrame:dateFrame] autorelease];
		dateLabel.backgroundColor = [UIColor clearColor];
		dateLabel.text		  = [self stringFromTwitterDate:tweet.created];
		dateLabel.font		  = [UIFont fontWithName:@"Helvetica-Bold" size:12.0f];
		dateLabel.textColor = [UIColor grayColor];

		CAGradientLayer *gradient = [CAGradientLayer layer];
		gradient.frame						= gradientFrame;
		gradient.colors						= gradArray;
		
		
		[hugeView addSubview:textField];
		[hugeView addSubview:dateLabel];
		[hugeView.layer insertSublayer:gradient atIndex:0];
	
		[cell addSubview:hugeView];
	}
	else if ( indexPath.section == 1 ) {
		if ( indexPath.row == 0 ) {
			cell.imageView.image = [UIImage imageNamed:@"retweet.png" scaledToSize:CGSizeMake(37, 37)];
			cell.textLabel.text = @"Re-Tweet";
			cell.textLabel.font = [UIFont boldSystemFontOfSize:20.0f];
			cell.textLabel.textColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1];
		}
		else {
			cell.imageView.image = [UIImage imageNamed:@"retweet.png" scaledToSize:CGSizeMake(37, 37)];
			cell.textLabel.text = @"Quote Tweet";
			cell.textLabel.font = [UIFont boldSystemFontOfSize:20.0f];
			cell.textLabel.textColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1];
		}
	}
}

- (NSString *)linkableText:(NSString *)text
{
	
	NSString *cmd;
	NSScanner *scanner = [NSScanner scannerWithString:text];
	[scanner scanString:@"http://" intoString:&cmd];
	//[scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"http://"] intoString:&cmd];

	NSString *args = [[scanner string] substringFromIndex:[scanner scanLocation]];

	return args;
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc
{
  [tweet release];
  [super dealloc];
}

@end
