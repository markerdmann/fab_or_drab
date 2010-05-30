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
	UIImage *image;
	NSData *imageData;
}

@property (nonatomic, retain) UIBarButtonItem *loginButton;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSData *imageData;

- (void) login:(id)sender;
- (void) snap:(id)sender;
- (void) sendImage:(id)sender;

- (void) uploadImage;

@end
