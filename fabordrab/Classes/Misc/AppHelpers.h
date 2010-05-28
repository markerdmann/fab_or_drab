//
//  AppHelpers.h
//  Schutt
//
//  Created by Mark Sands on 4/25/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

void AlertWithMessageAndDelegate(NSString *message, id theDelegate);
void AlertWithErrorAndDelegate(NSError *error, id theDelegate);