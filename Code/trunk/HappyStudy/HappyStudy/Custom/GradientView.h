//
//  GradientView.h
//  EasyLSP
//
//  Created by Quan on 15/5/8.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GradientView : UIView

- (instancetype)initWithFrame:(CGRect)frame fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor;
- (void)setFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor;
- (void)changeGradientFromPosition:(CGPoint)startPosition endPosition:(CGPoint)endPosition;

@end
