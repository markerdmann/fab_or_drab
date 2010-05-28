//
//  GradientTableViewCell.m
//  Schutt
//
//  Created by Mark Sands on 5/4/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//
// 

#import "GradientTableViewCell.h"

#define TOP_GRADIENT [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]
#define SHADOW_COLOR [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1.0]

#define Gradient_Colors [NSArray arrayWithObjects:\
(id)[TOP_GRADIENT CGColor], \
(id)[SHADOW_COLOR CGColor], nil];

#define Gradient_Height 20.0

@implementation GradientTableViewCell

/*
 * layoutSubviews
 * Last Modified: 4May2010
 * - Mark
 *
 * custom initialization of a Gradient colored tableCellView. Modeled after Tweetie's cells
 * The gray colored gradient is 246/246/246, the height of the frame is 20 pixels. I photoshoped it
 * next to Tweetie and its near perfect. HOWEVER, the cells aren't identical to Tweetie's so I 
 * have modified mine to be 20 pixels high with a gradient color of 244/244/244 which works best.
 * 
 * http://stackoverflow.com/questions/422066/gradients-on-uiview-and-uilabels-on-iphone/1931498#1931498
 * http://stackoverflow.com/questions/400965/how-to-customize-the-background-border-colors-of-a-grouped-table-view
 *
 */
- (void)layoutSubviews
{
  [super layoutSubviews];	

	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0, self.contentView.frame.size.height)];
	CAGradientLayer *gradient = [CAGradientLayer layer];
	gradient.frame = CGRectMake(view.bounds.origin.x, view.bounds.size.height - Gradient_Height, 320.0, Gradient_Height);
	gradient.colors = Gradient_Colors;
	[view.layer insertSublayer:gradient atIndex:0];
	
	self.backgroundView = view;
	[view release];
}

- (void) dealloc
{
	[super dealloc];
}

@end
