//
//  TwitterTableViewCell.h
//  Schutt
//
//  Created by Mark Sands on 4/25/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//
// http://blog.atebits.com/2008/12/fast-scrolling-in-tweetie-with-uitableview/
// 

#import <UIKit/UIKit.h>
#import "GradientTableViewCell.h"

@interface TwitterTableViewCell : GradientTableViewCell {

}

+ (id)cellWithReuseIdentifier:(NSString *)reuseIdentifier;
+ (CGFloat)heightForCellInTable:(UITableView *)aTableView withText:(NSString *)theText;

@end
