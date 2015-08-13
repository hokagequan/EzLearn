//
//  DaDiShuIndexCell.m
//  EasyLSP
//
//  Created by Q on 15/6/2.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "DaDiShuIndexCell.h"

@implementation DaDiShuIndexCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    self.soundMarkIV.hidden = !selected;
}

@end
