//
//  BaseTableViewController.m
//  Schutt
//
//  Created by Mark Sands on 4/26/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "BaseTableViewController.h"

#define DEBUG_VIEW 0

@interface BaseTableViewController (PrivateMethods)
- (void) backAction;
@end

@implementation BaseTableViewController

#if DEBUG_VIEW
- (void)loadView {
	NSLog(@"%@ loadView", [self class]);
	[super loadView];
}

- (void)viewDidLoad {
  NSLog(@"%@ viewDidLoad", [self class]);
  [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
  NSLog(@"%@ viewWillAppear:", [self class]);
  [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
  NSLog(@"%@ viewDidAppear:", [self class]);
  [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
  NSLog(@"%@ viewWillDisappear:", [self class]);
  [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
  NSLog(@"%@ viewDidDisappear:", [self class]);
  [super viewDidDisappear:animated];
}
	
- (void)viewDidUnload {
  NSLog(@"%@ viewDidUnload", [self class]);
}

- (void)didReceiveMemoryWarning {
  NSLog(@"%@ didReceiveMemoryWarning", [self class]);
  [super didReceiveMemoryWarning];
}

- (void)dealloc {
  NSLog(@"%@ dealloc", [self class]);
  [super dealloc];
}
#endif


/*
 * setGrayNavigationBarWithTitle
 * Last Modified: 6May2010
 * - Mark
 *
 * Source: http://stackoverflow.com/questions/599405/iphone-navigation-bar-title-text-color
 * http://stackoverflow.com/questions/2458995/invisible-back-button-when-view-controller-pushed-onto-navigation-controller
 * 
 * Sets the navigationBar to a lightGrayColor
 * Initializes the title text into a UILabel and spans it on the navigationBar, setting
 * the textColor to a dark gray 0.15f/0.15f/0.15f
 *
 * You MUST set the self.title in order for navigation controllers that are pushed onto the 
 * stack to have a visible back button!
 * 
 */
- (void) setGrayNavigationBarWithTitle:(NSString *)title
{
	self.navigationController.navigationBar.tintColor = [UIColor lightGrayColor];

	// this will appear as the title in the navigation bar
	CGRect frame = CGRectMake(0, 0, 400, 44);
	UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:20.0];
	label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	label.textAlignment = UITextAlignmentCenter;
	label.textColor = [UIColor colorWithRed:0.15f green:0.15f blue:0.15f alpha:1.0f];
	self.navigationItem.titleView = label;
	label.text = NSLocalizedString(title, @"");
	
	self.title = title;
}

/*
 * setColoredNavigationBarWithTitle
 * Last Modified: 6May2010
 * - Mark
 *
 * Sets the navigationBar to a specified color and initializes the title text.
 * 
 */
- (void) setColoredNavigationBarWithTitle:(NSString *)title andColor:(UIColor*)color
{
	self.navigationController.navigationBar.tintColor = color;
	self.title = title;
}

/*
 * tableView didSelectRowAtIndexPath
 * Last Modified: 4May2010
 * - Mark
 * 
 * Method to deselect the row upon selection. Cause the highlight is gay.
 * 
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

