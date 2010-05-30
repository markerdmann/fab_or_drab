//
//  FabOrDrab.m
//  fabordrab
//
//  Created by Mark Sands on 5/29/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "FabOrDrab.h"
#import "AppHelpers.h"

#import "TwitterLoginView.h"
#import "Camera.h"

@implementation FabOrDrab

@synthesize loginButton;
@synthesize view;

- (id) init
{	
	if ( self = [super init] ) {
		// success!
		self.title = @"Fab or Drab";

		loginButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign in" style:UIBarButtonItemStylePlain target:self action:@selector(login:)];
		self.navigationItem.rightBarButtonItem = loginButton;
		
		UIBarButtonItem *cameraBtn = [[UIBarButtonItem alloc] initWithTitle:@"Camera" style:UIBarButtonItemStylePlain target:self action:@selector(snap:)];
		self.navigationItem.leftBarButtonItem  = cameraBtn;
		
		view = [[UIView alloc] init];
	}

	return self;
}

- (void) login:(id)sender
{
	TwitterLoginView *next = [[TwitterLoginView alloc] init];
	[self.navigationController pushViewController:next animated:YES];
	[next release];
	
}

- (void) snap:(id)sender
{	
  UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];

	if([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
		imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
	} 
	else {
		imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	}

	imagePicker.allowsEditing = NO;
  
	imagePicker.delegate = self;
	imagePicker.allowsEditing = NO;
	
	[self.navigationController presentModalViewController:imagePicker animated:YES];	
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *image  = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
	
	UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	imageView2.image = image;

	NSLog(@"image: %@", image);

	//UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
	[picker release];

	[self.navigationController dismissModalViewControllerAnimated:YES];		
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{	
	if (error)
		AlertWithErrorAndDelegate(error, nil);
}

- (void)dealloc
{
	[loginButton release];
	[view release];
	[super dealloc];
}

@end