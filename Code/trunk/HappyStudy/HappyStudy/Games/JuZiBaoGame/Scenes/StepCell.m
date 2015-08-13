//
//  StepCell.m
//  EasyLSP
//
//  Created by Q on 15/5/29.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "StepCell.h"
#import "GradientView.h"

@interface StepCell()

@property (strong, nonatomic) IBOutletCollection(GradientView) NSArray *points;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stepBtnCenterYLC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pointOneCenterYLC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pointTwoCenterYLC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pointThreeCenterYLC;

@end

@implementation StepCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.stepBtn setBackgroundImage:[UIImage imageNamed:@"point_bg"]
                            forState:UIControlStateNormal];
    
    for (GradientView *point in self.points) {
        [point setFromColor:colorRGB(255, 216, 0, 1)
                    toColor:colorRGB(255, 168, 0, 1)];
        
        point.layer.cornerRadius = point.bounds.size.width / 2;
        point.layer.masksToBounds = YES;
    }
}

- (void)setStepBtnOffsetY:(CGFloat)offsetY {
    self.stepBtnCenterYLC.constant = offsetY;
}

- (void)setPointOffsetY:(CGFloat)offsetY {
    [self setPointHidden:NO];
    self.pointOneCenterYLC.constant = offsetY;
    self.pointTwoCenterYLC.constant = offsetY;
    self.pointThreeCenterYLC.constant = -offsetY;
}

- (void)setPointHidden:(BOOL)hidden {
    for (GradientView *point in self.points) {
        point.hidden = hidden;
    }
}

@end
