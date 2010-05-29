//
//  TwitterLoginView.h
//  fabordrab
//
//  Created by Mark Sands on 5/29/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterOauth.h"
#import "TextEntryCell.h"

@interface TwitterLoginView : UIViewController <UITextFieldDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, TwitterStatusDelegate> 
{
  TextEntryCell *usernameCell;
  TextEntryCell *passwordCell;
	
	UIBarButtonItem *sendButton;
  UITableView *tableView;
}

@property (nonatomic, retain) TextEntryCell *usernameCell;
@property (nonatomic, retain) TextEntryCell *passwordCell;
@property (nonatomic, retain) UIBarButtonItem *sendButton;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

- (void) sendTweet:(id)sender;

@end