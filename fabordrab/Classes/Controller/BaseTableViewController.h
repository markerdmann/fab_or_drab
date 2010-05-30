//
//  BaseTableViewController.h
//  Schutt
//
//  Created by Mark Sands on 4/26/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefreshTableViewController.h"

@interface BaseTableViewController : PullToRefreshTableViewController {

}

- (void) setGrayNavigationBarWithTitle:(NSString *)title;
- (void) setColoredNavigationBarWithTitle:(NSString *)title andColor:(UIColor*)color;

@end
