//
//  TwitterViewController.h
//  Schutt
//
//  Created by Mark Sands on 4/22/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "Twitter.h"
#import "AppHelpers.h"
#import "CJSONDeserializer.h"

#import "RetweetTableViewController.h"

@interface TwitterViewController : BaseTableViewController {
	NSMutableData *tweetsData;
	
	NSMutableDictionary *currentTweetDict;
	NSString *currentElementName;
	NSMutableString *currentText;
	
	NSMutableArray *tweetsArray;
}

@end