//
//  DDSQuestion.m
//  EasyLSP
//
//  Created by Quan on 15/5/7.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "JZBQuestion.h"

@implementation JZBQuestion

- (NSMutableArray *)titles {
    if (!_titles) {
        _titles = [NSMutableArray arrayWithCapacity:4];
    }
    
    return _titles;
}

@end
