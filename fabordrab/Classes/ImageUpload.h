//
//  ImageUpload.h
//  fabordrab
//
//  Created by Mark Sands on 5/30/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <HTTPRiot/HTTPRiot.h> 

@protocol UploadImageDelegate
@optional
- (void)imageUploadComplete;
@end

@interface ImageUpload : HRRestModel {

}

+ (void)uploadImage:(NSData *)imageData
					 delegate:(id)aDelegate;

@end