//
//  AppHelpers.m
//  Schutt
//
//  Created by Mark Sands on 4/25/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "AppHelpers.h"

/*
 * AlertWithMessageAndDelegate
 * Last Modified: 25April2010
 * - Mark
 * 
 * Helper method to show a UIAlertView with a given message
 *
 */
void AlertWithMessageAndDelegate(NSString *message, id theDelegate)
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
																									message:message
																								 delegate:theDelegate
																				cancelButtonTitle:@"OK"
																				otherButtonTitles:nil];

	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
	view.backgroundColor = [UIColor redColor];
	
	[alert show];
	[alert release];
}

/*
 * AlertWithErrorAndDelegate
 * Last Modified: 26April2010
 * - Mark
 *
 * Helper method to show a UIAlertView with a given error
 * Calls AlertWithMessageAndDelegate
 *
 */
void AlertWithErrorAndDelegate(NSError *error, id theDelegate)
{
	NSString* message = [[NSString stringWithFormat:@"Error:\n%@",[error localizedDescription]] capitalizedString];
	
	NSLog(@"\n%@", message);
	AlertWithMessageAndDelegate(message, theDelegate);
}
