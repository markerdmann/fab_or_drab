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

#import "Twitter.h"


@interface RetweetViewController : PushedBaseTableViewController {
	Twitter *tweet;
}

@property (nonatomic, retain) Twitter *tweet;

- (id) initWithTweet:(Twitter *)twt;

@end