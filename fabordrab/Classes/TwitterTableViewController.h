//
//  TwitterViewController.h
//  Schutt
//
//  Created by Mark Sands on 4/22/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "Tweet.h"
#import "Misc/AppHelpers.h"
#import "JSON/CJSONDeserializer.h"

#import "RetweetTableViewController.h"
#import "TwitterLoginView.h"

@interface TwitterTableViewController : BaseTableViewController {
	NSMutableData *tweetsData;
	
	NSMutableDictionary *currentTweetDict;
	NSString *currentElementName;
	NSMutableString *currentText;
	
	NSMutableArray *tweetsArray;
}

@end