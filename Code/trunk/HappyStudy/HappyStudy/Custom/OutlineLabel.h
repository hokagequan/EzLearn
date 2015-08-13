//
//  OutlineLabel.h
//  EasyLSP
//
//  Created by Quan on 15/5/14.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OutlineLabel : UILabel

@property (strong, nonatomic) UIColor *borderColor;

- (instancetype)initWithTextColor:(UIColor *)textColor borderColor:(UIColor *)borderColor;

@end
