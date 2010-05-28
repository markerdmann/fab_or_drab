//
//  PushedBaseTableViewController.h
//  Schutt
//
//  Created by Mark Sands on 5/7/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PushedBaseTableViewController : UITableViewController {

}
- (void) setColoredNavigationBarWithTitle:(NSString *)title andColor:(UIColor*)color;

- (void) setGrayNavigationBarWithTitle:(NSString *)title;
- (void) setGrayNavBarBackButton;


@end
