//
//  Twitter.m
//  Schutt
//
//  Created by Mark Sands on 4/18/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

@synthesize created   = _created;
@synthesize text      = _text;

- (void) dealloc
{
	[_created release];
	[_text release];
  [super dealloc];
}
	
@end
