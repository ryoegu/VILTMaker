//
//  BorderButton.m
//  o2
//
//  Created by Ryo Eguchi on 2015/08/24.
//  Copyright (c) 2015年 Ryo Eguchi. All rights reserved.
//

#import "BorderButton.h"

@implementation BorderButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return self;
    _borderColor = [UIColor blackColor];
    _borderWidth = 0;
    _cornerRadius = 0;
    return self;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    self.layer.borderColor = _borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    self.layer.borderWidth = _borderWidth;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
}

@end
