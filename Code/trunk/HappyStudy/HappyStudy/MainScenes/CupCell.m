//
//  CupCell.m
//  EasyLSP
//
//  Created by Q on 15/6/4.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "CupCell.h"

@implementation CupCell

- (void)awakeFromNib {
    // Initialization code
    self.border.layer.cornerRadius = 2.0;
    self.border.layer.masksToBounds = YES;
    self.titleLab.numberOfLines = 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickExchange:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickExchange:)]) {
        [self.delegate didClickExchange:self];
    }
}

@end
