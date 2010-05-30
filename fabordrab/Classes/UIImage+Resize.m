//
//  UIImage+Resize.m
//  Schutt
//
//  Created by Mark Sands on 5/7/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "UIImage+Resize.h"


@implementation UIImage (Resize)

/*
 * imageNamed scaledToSize
 * Last Modified: 7May2010
 * - Mark
 *
 * Initializes an image by scaling it to a pre-determined size
 * http://stackoverflow.com/questions/603907/uiimage-resize-then-crop
 * http://stackoverflow.com/questions/205431/rounded-corners-on-uiimage
 *
 */

+ (UIImage*)imageNamed:(NSString*)imageName scaledToSize:(CGSize)newSize
{
	UIGraphicsBeginImageContext( newSize );
	[[UIImage imageNamed:imageName] drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
		
	return newImage;
}

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
	UIGraphicsBeginImageContext( newSize );
	[image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
		
	return newImage;
}

@end
