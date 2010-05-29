//
//  TwitterOauth.h
//  fabordrab
//
//  Created by Mark Sands on 5/29/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <HTTPRiot/HTTPRiot.h> 

@protocol TFTwitterStatusDelegate
@optional
	- (void)statusUpdateComplete;
@end

@interface TwitterOauth : HRRestModel {
  
}

+ (void)postStatus:(NSString *)status 
      withUsername:(NSString *)username
          password:(NSString *)password
          delegate:(id)aDelegate;

@end