//
//  Twitter.h
//  Schutt
//
//  Created by Mark Sands on 4/18/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : NSObject
{
	NSDate *_created;
  NSString *_text;
}

@property (nonatomic, retain) NSDate*   created;
@property (nonatomic, copy)   NSString* text;

@end