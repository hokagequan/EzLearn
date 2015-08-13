//
//  OutlineLabel.m
//  EasyLSP
//
//  Created by Quan on 15/5/14.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "OutlineLabel.h"

@implementation OutlineLabel

- (instancetype)initWithTextColor:(UIColor *)textColor borderColor:(UIColor *)borderColor {
    if (self = [super init]) {
        self.textColor = textColor;
        self.borderColor = borderColor;
    }
    
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    
    CGSize shadowOffset = self.shadowOffset;
    UIColor *textColor = self.textColor;
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(c, 2);
    CGContextSetLineJoin(c, kCGLineJoinRound);
    
    CGContextSetTextDrawingMode(c, kCGTextStroke);
    self.textColor = self.borderColor;
    [super drawTextInRect:rect];
    
    CGContextSetTextDrawingMode(c, kCGTextFill);
    self.textColor = textColor;
    self.shadowOffset = CGSizeMake(0, 0);
    [super drawTextInRect:rect];
    
    self.shadowOffset = shadowOffset;
}

@end
