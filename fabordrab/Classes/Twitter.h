//
//  Twitter.h
//  Schutt
//
//  Created by Mark Sands on 4/18/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <HTTPRiot/HTTPRiot.h> 

@interface Twitter : NSObject
{
	NSDate *_created;
  NSString *_text;
}

@property (nonatomic, retain) NSDate*   created;
@property (nonatomic, copy)   NSString* text;

@end
