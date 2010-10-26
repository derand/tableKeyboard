//
//  rightViewCell.m
//  follow2iPhoneSettings
//
//  Created by maliy on 11/25/09.
//  Copyright 2009 interMobile. All rights reserved.
//

#import "rightViewCell.h"


// table view cell content offsets
#define kCellLeftOffset			8.0
#define kCellTopOffset			8.0
#define kCellHeight				25.0
#define kPageControlWidth		160.0


@implementation rightViewCell
@synthesize view;
@synthesize activeBounds;

#pragma mark lifeCycle

- (id) initWithStyle:(UITableViewCellStyle) style reuseIdentifier:(NSString *) identifier
{
    if (self = [super initWithStyle:style reuseIdentifier:identifier])
	{
		// turn off selection use
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		self.detailTextLabel.backgroundColor = [UIColor clearColor];
		
		activeBounds = YES;
	}
	return self;
}

- (void)dealloc
{
	[view release];
	
    [super dealloc];
}

#pragma mark -

- (void)setView:(UIView *)inView
{
	if (view != inView)
	{
		if (view)
		{
			[view removeFromSuperview];
			[view release];
		}
		view = [inView retain];
		[self.contentView addSubview:view];
	}
	
	[self layoutSubviews];
}

- (void) layoutSubviews
{	
	[super layoutSubviews];
    CGRect contentRect = [self.contentView bounds];
	
	// In this example we will never be editing, but this illustrates the appropriate pattern
	CGRect frame = CGRectMake(contentRect.origin.x + kCellLeftOffset, kCellTopOffset, contentRect.size.width, kCellHeight);
//	self.textLabel.frame = frame;
	
	if ([view isKindOfClass:[UIPageControl class]])
	{
		// special case UIPageControl since its width changes after its creation
		frame = self.view.frame;
		frame.size.width = kPageControlWidth;
		self.view.frame = frame;
	}
	
	CGRect uiFrame;
	if (self.textLabel==nil || [@""isEqualToString:self.textLabel.text] || self.textLabel.text==nil)
	{
		CGSize bb = CGSizeMake(kCellLeftOffset, kCellTopOffset);
		if (!activeBounds)
			bb = CGSizeZero;
		uiFrame = CGRectMake(contentRect.origin.x + bb.width,
							 contentRect.origin.y + bb.height,
							 contentRect.size.width - (bb.width*2.0),
							 contentRect.size.height - (bb.height*2.0));
	}
	else 
	{
		uiFrame = CGRectMake(contentRect.size.width - self.view.bounds.size.width - kCellLeftOffset - 1.0,
							 round((contentRect.size.height - self.view.bounds.size.height) / 2.0),
							 self.view.bounds.size.width,
							 self.view.bounds.size.height);
	}
	view.frame = uiFrame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	[super setSelected:selected animated:animated];
	
	// when the selected state changes, set the highlighted state of the lables accordingly
//	self.textLabel.highlighted = selected;
}

@end
