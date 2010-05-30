//
//  PushedBaseTableViewController.m
//  Schutt
//
//  Created by Mark Sands on 5/7/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "PushedBaseTableViewController.h"

@interface PushedBaseTableViewController (PrivateMethods)
- (void) backAction;
@end


@implementation PushedBaseTableViewController


/*
 * setPushedGrayNavigationBarWithTitle
 * Last Modified: 6May2010
 * - Mark
 *
 * http://stackoverflow.com/questions/599405/iphone-navigation-bar-title-text-color
 * http://stackoverflow.com/questions/2458995/invisible-back-button-when-view-controller-pushed-onto-navigation-controller
 * 
 * Sets the navigationBar to a lightGrayColor
 * Initializes the title text into a UILabel and spans it on the navigationBar, setting
 * the textColor to a dark gray 0.15f/0.15f/0.15f
 * You MUST set the self.title in order for navigation controllers that are pushed onto the 
 * stack to have a visible back button!
 * 
 */
- (void) setGrayNavigationBarWithTitle:(NSString *)title
{
	self.navigationController.navigationBar.tintColor = [UIColor lightGrayColor];
	
	UILabel *label = [[[UILabel alloc] init] autorelease];
	[label setFrame:CGRectMake(0, 0, 100, 44)];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:20.0];
	label.textAlignment = UITextAlignmentCenter;
	label.textColor = [UIColor colorWithRed:0.15f green:0.15f blue:0.15f alpha:1.0f];
	self.navigationItem.titleView = label;
	label.text = NSLocalizedString(title, @"");
}

/*
 * setGrayNavBarBackButton:(SEL)action
 * Last Modified: 7May2010
 * - Mark
 * 
 * I scowered the Internet looking for ways to create a custom back button
 * with black text. Basically, I wound up creating a photoshop version of the 
 * back button with supplike 'Back' text. I saved the PSDs in case that needs
 * to be changed. 
 * I create a UIButton with custom type and set the plain and highlighted images according.
 * The button calls the selector backAction to pop the view controller from the stack.
 * And finally, the leftBarButtonItem is assigned to a UIBarButtonItem withCustomView of the 
 * custom button.
 * 
 */
- (void) setGrayNavBarBackButton
{	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	
	button.frame = CGRectMake(0, 0, 60, 30);
	
	[button setImage:[UIImage imageNamed:@"UIBackBarButtonPlain.png"] forState:UIControlStateNormal];
	[button setImage:[UIImage imageNamed:@"UIBackBarButtonHighlighted.png"] forState:UIControlStateHighlighted];		
	
	[button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem *bbi = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
	self.navigationItem.leftBarButtonItem = bbi;
}

/* 
 * backAction
 * LastModified: 6May2010
 * - Mark
 * 
 * wrapper selector to perform an action when the user presses the 'back' 
 * button on the navigationController
 *
 */
- (void) backAction
{ 
	[self.navigationController popViewControllerAnimated:YES]; 
}

@end

