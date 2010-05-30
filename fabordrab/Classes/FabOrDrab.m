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

#import "ImageUpload.h"

#import <QuartzCore/QuartzCore.h>

@implementation FabOrDrab

@synthesize loginButton;
@synthesize image;
@synthesize imageData;

- (id) init
{	
	if ( self = [super init] ) {
		// success!
		self.title = @"Fab or Drab";

		loginButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign in" style:UIBarButtonItemStylePlain target:self action:@selector(login:)];
		self.navigationItem.rightBarButtonItem = loginButton;
		
		UIBarButtonItem *cameraBtn = [[UIBarButtonItem alloc] initWithTitle:@"Camera" style:UIBarButtonItemStylePlain target:self action:@selector(snap:)];
		self.navigationItem.leftBarButtonItem  = cameraBtn;
		
		image = [[UIImage alloc] init];
		imageData = [[NSData alloc] init];
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
	UIImage *imageFromCam = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
	
	//self.imageData = UIImagePNGRepresentation(imageFromCam);
	self.imageData = UIImageJPEGRepresentation(imageFromCam, 90);

	//[self sendImage:self];
	[self uploadImage];

	//UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
	[picker release];

	[self.navigationController dismissModalViewControllerAnimated:YES];		
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{	
	if (error)
		AlertWithErrorAndDelegate(error, nil);
}

- (void) sendImage:(id)sender
{	
	[ImageUpload uploadImage:self.imageData
									delegate:self];
}

- (void)dealloc
{
	[loginButton release];
	[image release];
	[imageData release];
	[super dealloc];
}





- (void) uploadImage {

	// create the URL
	NSURL *postURL = [NSURL URLWithString:@"http://fabordrab.heroku.com/upload"];
	
	// create the connection
	NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:postURL
																														 cachePolicy:NSURLRequestUseProtocolCachePolicy
																												 timeoutInterval:30.0];
	
	// change type to POST (default is GET)
	[postRequest setHTTPMethod:@"POST"];
	
	
	// just some random text that will never occur in the body
	NSString *stringBoundary = @"0xKhTmLbOuNdArY---This_Is_ThE_BoUnDaRyy---pqo";
	
	// header value
	NSString *headerBoundary = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",
															stringBoundary];
	
	// set header
	[postRequest addValue:headerBoundary forHTTPHeaderField:@"Content-Type"];
	
	// create data
	NSMutableData *postBody = [NSMutableData data];
	
	NSString *username = @"marksands2";
	NSString *password = @"raidmax";
	NSString *message = @"Testing TwitPic Upload for Blog Post";
	
	// username part
	[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"username\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[username dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
	// password part
	[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"password\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[password dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
	// message part
	[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"message\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[message dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
	// media part
	[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"Content-Disposition: form-data; name=\"datafile\"; filename=\"dummy.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"Content-Type: image/jpeg\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
	// get the image data from main bundle directly into NSData object

	NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"retweet" ofType:@"png"];
	NSData *imageData2 = [NSData dataWithContentsOfFile:imagePath];
	
	// add it to body
	[postBody appendData:imageData2];
	[postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
	// final boundary
	[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	// add body to post
	[postRequest setHTTPBody:postBody];
	
	// pointers to some necessary objects
	NSURLResponse* response;
	NSError* error;
	
	// synchronous filling of data from HTTP POST response
	NSData *responseData = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:&response error:&error];
	
	if (error)
	{
		NSLog(@"Error: %@", [error localizedDescription]);
	}
	
	// convert data into string
	NSString *responseString = [[[NSString alloc] initWithBytes:[responseData bytes]
																											 length:[responseData length]
																										 encoding:NSUTF8StringEncoding] autorelease];
	
	// see if we get a welcome result
	NSLog(@"%@", responseString);
}


@end