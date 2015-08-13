//
//  GradientView.m
//  EasyLSP
//
//  Created by Quan on 15/5/8.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "GradientView.h"

@interface GradientView()

@property (strong, nonatomic) UIColor *fromColor;
@property (strong, nonatomic) UIColor *toColor;

@property (nonatomic) CGPoint startPosition;
@property (nonatomic) CGPoint endPosition;

@end

@implementation GradientView

- (instancetype)initWithFrame:(CGRect)frame fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor {
    if (self = [super initWithFrame:frame]) {
        self.fromColor = fromColor;
        self.toColor = toColor;
        
        self.startPosition = CGPointMake(self.bounds.size.width / 2, 0);
        self.endPosition = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height);
    }
    
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGGradientRef gradient;
    CGColorSpaceRef colorSpace;
    
    CGFloat locations[4] = {0.0, 1.0};
    NSArray *colors = @[(id)self.fromColor.CGColor, (id)self.toColor.CGColor];
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)colors, locations);
    
    CGContextDrawLinearGradient(context, gradient, self.startPosition, self.endPosition, 0);
}

- (void)changeGradientFromPosition:(CGPoint)startPosition endPosition:(CGPoint)endPosition {
    self.startPosition = startPosition;
    self.endPosition = endPosition;
    
    [self setNeedsDisplay];
}

- (void)setFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor {
    self.fromColor = fromColor;
    self.toColor = toColor;
    
    [self layoutIfNeeded];
}

@end
