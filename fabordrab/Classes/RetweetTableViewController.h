//
//  RetweetViewController.h
//  Schutt
//
//  Created by Mark Sands on 5/6/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PushedBaseTableViewController.h"

#import "AppHelpers.h"
#import "UIImage+Resize.h"

#import "Tweet.h"


@interface RetweetViewController : PushedBaseTableViewController {
	Tweet *tweet;
}

@property (nonatomic, retain) Tweet *tweet;

- (id) initWithTweet:(Tweet *)twt;

@end