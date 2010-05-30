//
//  FabOrDrab.h
//  fabordrab
//
//  Created by Mark Sands on 5/29/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FabOrDrab : UIViewController
{
	UIBarButtonItem *loginButton;
}

@property (nonatomic, retain) UIBarButtonItem *loginButton;

- (void) login:(id)sender;

@end