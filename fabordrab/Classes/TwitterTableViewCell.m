    //
//  TwitterTableViewCell.m
//  Schutt
//
//  Created by Mark Sands on 4/25/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "TwitterTableViewCell.h"

#define TwitterCellTextFont [UIFont fontWithName:@"Verdana" size:14.0f]
#define TwitterDateCellTextFont [UIFont fontWithName:@"Helvetica-Bold" size:12.0f]

#define OLD_TwitterCellTextFont     [UIFont systemFontOfSize:14.0f]
#define OLD_TwitterDateCellTextFont [UIFont systemFontOfSize:12.0f]

#define TwitterCellTextLeftMargin 10.0f
#define TwitterCellMargin 5.0f
#define TwitterCellDateHeight 26.0f

@implementation TwitterTableViewCell

/*
 * cellWithReuseIdentifier
 * Last Modified: 25April2010
 * - Mark
 *
 * convenience method for simplicity
 *
 */
+ (id) cellWithReuseIdentifier:(NSString *)reuseIdentifier
{
  return [[[self alloc] initWithStyle:UITableViewCellStyleValue2
											reuseIdentifier:reuseIdentifier] autorelease];
}

/*
 * heightForCellInTable withText
 * Last Modified: 25April2010
 * - Mark
 *
 * Runs calculation of cell height on the given text, returns the cell height
 *
 */
+ (CGFloat) heightForCellInTable:(UITableView *)tableView 
                        withText:(NSString *)theText
{
  CGFloat cellWidth = tableView.frame.size.width;
	
  if (tableView.style == UITableViewStyleGrouped)
    cellWidth -= 20.0f;
	
  // NOTE: FLT_MAX is a large float. Returned height will be less.
  CGSize targetSize = CGSizeMake(cellWidth - TwitterCellTextLeftMargin - TwitterCellMargin, 
                                 FLT_MAX);
  CGSize cellSize = [theText sizeWithFont:TwitterCellTextFont 
                        constrainedToSize:targetSize
                            lineBreakMode:UILineBreakModeWordWrap];
	
	cellSize = [theText sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:16.0f]
								 constrainedToSize:targetSize
										 lineBreakMode:UILineBreakModeWordWrap];

  // NOTE: 1.0f for the bottom pixel line on the row
  cellSize.height += (2.0f * TwitterCellMargin) + 1.0f;

	// For the Date
	cellSize.height += TwitterCellDateHeight;

  return cellSize.height;
}

/*
 * layoutSubviews
 * Last Modified: 25April2010
 * - Mark
 *
 * custom initialization of Twitter's tableCellView
 * 
 */
- (void)layoutSubviews
{
  [super layoutSubviews];	
	
	CGRect labelFrame      = self.contentView.frame;
  labelFrame.size.width  = self.contentView.frame.size.width - TwitterCellTextLeftMargin - TwitterCellMargin;
  labelFrame.size.height = self.contentView.frame.size.height - (2.0f * TwitterCellMargin) - TwitterCellDateHeight;
  labelFrame.origin.x    = TwitterCellTextLeftMargin;
  labelFrame.origin.y    = TwitterCellMargin;

  self.detailTextLabel.frame					 = labelFrame;
  self.detailTextLabel.font						 = TwitterCellTextFont;
  self.detailTextLabel.lineBreakMode	 = UILineBreakModeWordWrap;
  self.detailTextLabel.numberOfLines	 = 0;
	self.detailTextLabel.backgroundColor = [UIColor clearColor];
	
	CGRect dateFrame			= self.contentView.frame;
	dateFrame.size.width  = self.contentView.frame.size.width - TwitterCellTextLeftMargin - TwitterCellMargin;
  dateFrame.size.height = TwitterCellDateHeight;
	dateFrame.origin.x		= TwitterCellTextLeftMargin;
	dateFrame.origin.y		=	labelFrame.size.height + TwitterCellMargin;
	
	self.textLabel.frame				   = dateFrame;
	self.textLabel.lineBreakMode   = UILineBreakModeWordWrap;
	self.textLabel.numberOfLines   = 0;
	self.textLabel.font            = TwitterDateCellTextFont;
	self.textLabel.backgroundColor = [UIColor clearColor];
}

- (void)dealloc
{
  [super dealloc];
}

@end