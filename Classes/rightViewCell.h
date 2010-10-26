//
//  rightViewCell.h
//  follow2iPhoneSettings
//
//  Created by maliy on 11/25/09.
//  Copyright 2009 interMobile. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface rightViewCell : UITableViewCell
{
	UIView	*view;
	BOOL activeBounds;
}

@property (nonatomic, retain) UIView *view;
@property (nonatomic, assign) BOOL activeBounds;

- (id) initWithStyle:(UITableViewCellStyle) style reuseIdentifier:(NSString *) identifier;
- (void) setView:(UIView *) inView;


@end
