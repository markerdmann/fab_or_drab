//
//  TwitterLoginView.m
//  fabordrab
//
//  Created by Mark Sands on 5/29/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "TwitterLoginView.h"

@implementation TwitterLoginView

@synthesize usernameCell;
@synthesize passwordCell;
@synthesize sendButton;
@synthesize tableView;

- (id) init
{
	if ( self = [super initWithNibName:@"TwitterLoginController" bundle:nil]) {
		// success!
		sendButton = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStylePlain target:self action:@selector(sendTweet:)];
		self.navigationItem.rightBarButtonItem = sendButton;
	}
	return self;
}

 - (TextEntryCell *)createCell
{
  NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TextEntryCell" owner:nil options:nil];
  TextEntryCell *cell = [nib objectAtIndex:0];
  cell.delegate = self;
  cell.keyboardType = UIKeyboardTypeDefault;
  cell.autocorrectionType = UITextAutocorrectionTypeNo;
  cell.autocapitalizationType = UITextAutocapitalizationTypeNone;
  cell.enablesReturnKeyAutomatically = YES;
  cell.returnKeyType = UIReturnKeyNext;
  return cell;
}

- (void)viewDidLoad
{
  self.usernameCell = [self createCell];
  self.usernameCell.label.text = @"Username";
  
  self.passwordCell = [self createCell];
  self.passwordCell.label.text = @"Password";
  self.passwordCell.secureTextEntry = YES;
}

- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self.usernameCell becomeFirstResponder];
}

- (void)viewDidUnload
{
  self.usernameCell = nil;
  self.passwordCell = nil;
  self.sendButton = nil;
  self.tableView = nil;
}

#pragma mark UIActions

- (void) sendTweet:(id)sender
{
  [self.usernameCell resignFirstResponder];
  [self.passwordCell resignFirstResponder];
	  
  [TwitterOauth postStatus:@"Test!"
							withUsername:self.usernameCell.text
									password:self.passwordCell.text
									delegate:self];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section == 0) {
		return @"Please enter your Twitter credentials:";
	} else {
		return @"ZOMGWTFBBQ?!";
	}

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
  }
  
	if (indexPath.row == 0) {
		return self.usernameCell;
	}
	else {
		return self.passwordCell;
	}

  return cell;
}

- (void)dealloc {
  [usernameCell release];
  [passwordCell release];
  [sendButton release];
  [tableView release];
  [super dealloc];
}

#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  if (textField == self.usernameCell.textField) {
    [self.usernameCell resignFirstResponder];
    [self.passwordCell becomeFirstResponder];
  }
  else if (textField == self.passwordCell.textField) {
    [self.passwordCell resignFirstResponder];
  }
  return YES;
}

#pragma mark TwitterStatus Delegate

- (void)statusUpdateComplete
{
  [self.parentViewController dismissModalViewControllerAnimated:YES];
}

@end
