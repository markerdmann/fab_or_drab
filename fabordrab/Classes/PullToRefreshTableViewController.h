//
//  PullToRefreshTableViewController.h
//  Schutt
//
//  Created by Mark Sands on 4/24/10.
//  Copyright 2010 Apple Inc. All rights reserved.

/*
 * PullToRefreshTableViewController:
 * http://www.drobnik.com/touch/2009/12/how-to-make-a-pull-to-reload-tableview-just-like-tweetie-2/
 */

#import <UIKit/UIKit.h>
#import "RefreshTableHeaderView.h"
#import "LoggingViewController.h"

@interface PullToRefreshTableViewController : UITableViewController {
	
	RefreshTableHeaderView *refreshHeaderView;
	
	BOOL checkForRefresh;
	BOOL _reloading;
	
	//	Balto *SoundEffect;
	//	SoundEffect *psst1Sound;
	//	SoundEffect *psst2Sound;
	//	SoundEffect *popSound;
}

@property (assign,getter=isReloading) BOOL reloading;

- (void) reloadTableViewDataSource;
- (void) doneLoadingTableViewData;

- (void) loadTableData;

@end
