//
//  fabordrabAppDelegate.h
//  fabordrab
//
//  Created by Mark Sands on 5/28/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface fabordrabAppDelegate : NSObject <UIApplicationDelegate>
{    
	UIWindow *window;
	UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

