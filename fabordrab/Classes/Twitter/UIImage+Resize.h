//
//  UIImage+Resize.h
//  Schutt
//
//  Created by Mark Sands on 5/7/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)

+ (UIImage*)imageNamed:(NSString*)imageName scaledToSize:(CGSize)newSize;

@end
