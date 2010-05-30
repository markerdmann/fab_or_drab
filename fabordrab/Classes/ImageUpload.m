//
//  ImageUpload.m
//  fabordrab
//
//  Created by Mark Sands on 5/30/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "ImageUpload.h"
#import "AppHelpers.h"

@implementation ImageUpload

+ (void)initialize
{	
	NSString *boundary = @"0xKhTmLbOuNdArY---This_Is_ThE_BoUnDaRyy---pqo";
	NSString *type     = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
											
	NSDictionary *headers = [NSDictionary dictionaryWithObject:type forKey:@"Content-Type"];
	 	
  [self setHeaders:headers];
  [self setBaseURL:[NSURL URLWithString:@"http://fabordrab.heroku.com"]];
  [self setDelegate:self];
}

+ (void)uploadImage:(NSData*)imageData
					 delegate:(id)aDelegate
{
	NSString *boundary = @"0xKhTmLbOuNdArY---This_Is_ThE_BoUnDaRyy---pqo";

	NSMutableData *postBody = [NSMutableData data];

	// media part
	[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"Content-Disposition: form-data; name=\"datafile\"; filename=\"zadfasd98d.png\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"Content-Type: image/png\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

	// add it to body
	[postBody appendData:imageData];
	[postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
	// final boundary
	[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];

  NSDictionary *opts = [NSDictionary dictionaryWithObject:postBody forKey:@""];
  [self postPath:@"/upload" withOptions:opts object:aDelegate];
}

#pragma mark HRRequestOperation delegate methods

+ (void)restConnection:(NSURLConnection *)connection 
didFailWithError:(NSError *)error 
object:(id)object {
  // Handle connection errors.  Failures to connect to the server, etc.
	NSLog(@"failed to connect to server");
	AlertWithErrorAndDelegate(error, nil);
}

+ (void)restConnection:(NSURLConnection *)connection 
didReceiveError:(NSError *)error 
response:(NSHTTPURLResponse *)response object:(id)object {
  // Handle invalid responses, 404, 500, etc.
	int statusCode = [(NSHTTPURLResponse *)response statusCode];
	NSLog(@"Invalid respone: %d", statusCode);
	AlertWithErrorAndDelegate(error, nil);
}

+ (void)restConnection:(NSURLConnection *)connection 
didReceiveParseError:(NSError *)error 
responseBody:(NSString *)string {
  // Request was successful, but couldn't parse the data returned by the server. 
	NSLog(@"Close..");
	AlertWithErrorAndDelegate(error, nil);
}

// Fires off method in delegate: receivedNewsItems:
+ (void)restConnection:(NSURLConnection *)connection 
		 didReturnResource:(id)resource 
								object:(id)anObject {
	
	NSLog(@"resource: %@",resource);
	NSLog(@"object:   %@",anObject);
	
  if ([anObject respondsToSelector:@selector(imageUploadComplete)]) {
    [anObject imageUploadComplete];
  }
}

@end

