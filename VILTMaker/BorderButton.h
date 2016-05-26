//
//  BorderButton.h
//  o2
//
//  Created by Ryo Eguchi on 2015/08/24.
//  Copyright (c) 2015年 Ryo Eguchi. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface BorderButton : UIButton

@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable CGFloat cornerRadius;

@end
