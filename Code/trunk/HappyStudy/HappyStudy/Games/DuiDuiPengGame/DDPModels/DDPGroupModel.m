//
//  DDPGroupModel.m
//  HappyStudy
//
//  Created by Quan on 14/10/22.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "DDPGroupModel.h"

@implementation DDPGroupModel

- (id)init {
    if (self = [super init]) {
        _pyModels = [[NSMutableArray alloc] init];
        _hzModels = [[NSMutableArray alloc] init];
    }
    
    return self;
}

@end
