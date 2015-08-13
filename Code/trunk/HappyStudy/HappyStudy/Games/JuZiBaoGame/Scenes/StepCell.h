//
//  StepCell.h
//  EasyLSP
//
//  Created by Q on 15/5/29.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StepCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *stepBtn;

- (void)setStepBtnOffsetY:(CGFloat)offsetY;
- (void)setPointOffsetY:(CGFloat)offsetY;
- (void)setPointHidden:(BOOL)hidden;

@end
