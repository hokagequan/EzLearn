//
//  PZCIndividualMgr.m
//  EasyLSP
//
//  Created by Quan on 15/6/16.
//  Copyright © 2015年 LittleIsland. All rights reserved.
//

#import "PZCIndividualMgr.h"
#import "PinZiChuiIndividualScene.h"
#import "DDSModel.h"
#import "DDSOption.h"

@implementation PZCIndividualMgr

- (BOOL)decreaseScore {
    [super decreaseScore];
    
    if (self.life == 0) {
        [self gameEnd];
        [self.gameScene gameOver];
        
        return YES;
    }
    
    return NO;
}

- (void)wrong {
    self.clickCount++;
    DDSModel *model = self.models[self.gameScene.curIndex];
    NSMutableArray *options = [NSMutableArray array];
    for (DDSOption *option in model.options) {
        [options addObject:option.title];
    }
    
    [self wrong:model.modelID options:options];
    
    if (![self decreaseScore]) {
        [self goNext];
    }
}

@end
