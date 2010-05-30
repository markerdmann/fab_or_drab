//
//  TextEntryCell.h
//  fabordrab
//
//  Created by Mark Sands on 5/29/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TextEntryCell : UITableViewCell <UITextInputTraits> {
  UILabel *label;
  UITextField *textField;
  id<UITextFieldDelegate> delegate;	
}

@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (nonatomic, retain) id<UITextFieldDelegate> delegate;

- (NSString *)text;
- (void)becomeFirstResponder;
- (void)resignFirstResponder;

@end