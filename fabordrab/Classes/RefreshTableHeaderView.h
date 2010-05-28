//
//  RefreshTableViewHeader.h
//  Schutt
//
//  Created by Mark Sands on 4/24/10.
//  Copyright 2010 Apple Inc. All rights reserved.

/* Sources:
 *
 * PullToRefreshTableViewController:
 * http://www.drobnik.com/touch/2009/12/how-to-make-a-pull-to-reload-tableview-just-like-tweetie-2/
 *
 * RefreshTableHeaderView:
 * http://github.com/enormego/EGOTableViewPullRefresh/
 */

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum {
	PullRefreshPulling = 0,
	PullRefreshNormal,
	PullRefreshLoading,	
} PullRefreshState;

@interface RefreshTableHeaderView : UIView {
	
	UILabel *lastUpdatedLabel;
	UILabel *statusLabel;
	CALayer *arrowImage;
	UIActivityIndicatorView *activityView;
	
	PullRefreshState _state;
	
}

@property (nonatomic,assign) PullRefreshState state;

- (void)setCurrentDate;
- (void)setState:(PullRefreshState) aState;

@end