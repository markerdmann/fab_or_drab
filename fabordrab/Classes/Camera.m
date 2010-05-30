//
//  Camera.m
//  fabordrab
//
//  Created by Mark Sands on 5/29/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "Camera.h"
#import "AppHelpers.h"

@implementation Camera

- (id) init
{
	if ( self = [super init] ) {
		if([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
			self.sourceType = UIImagePickerControllerSourceTypeCamera;
		} 
		else {
			self.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		}
		self.allowsEditing = NO;
		
	}
	return self;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
	UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

	NSLog(@"image: %@",image);
	
	[self.navigationController dismissModalViewControllerAnimated:YES];		
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{	
	if (error)
		AlertWithErrorAndDelegate(error, nil);
}

- (void)dealloc
{
	[super dealloc];
}

@end