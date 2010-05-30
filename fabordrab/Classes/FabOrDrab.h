//
//  FabOrDrab.h
//  fabordrab
//
//  Created by Mark Sands on 5/29/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FabOrDrab : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
	UIBarButtonItem *loginButton;
	UIView *view;
}

@property (nonatomic, retain) UIBarButtonItem *loginButton;
@property (nonatomic, retain) IBOutlet UIView *view;

- (void) login:(id)sender;
- (void) snap:(id)sender;

@end