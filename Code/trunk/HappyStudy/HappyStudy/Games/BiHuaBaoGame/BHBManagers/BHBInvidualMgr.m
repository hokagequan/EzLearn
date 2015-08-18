//
//  BHBInvidualMgr.m
//  EasyLSP
//
//  Created by Q on 15/8/17.
//  Copyright © 2015年 LittleIsland. All rights reserved.
//

#import "BHBInvidualMgr.h"
#import "BiHuaBaoIndividualScene.h"
#import "BHBModel.h"

@implementation BHBInvidualMgr

- (instancetype)init {
    if (self = [super init]) {
        self.totalTime = 10;
    }
    
    return self;
}

- (void)countingDown {
    self.leftTime--;
    [self.gameScene refreshTime:self.leftTime];
    
    if (self.leftTime <= 0) {
        [self.timer invalidate];
        self.timer = nil;
        
        [self wrong];
    }
}

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
    [self.gameScene playWrongSound];
    
    self.clickCount++;
    BHBModel *model = self.models[self.gameScene.curIndex];
    NSMutableArray *options = [NSMutableArray array];
    for (BHBOption *option in model.options) {
        [options addObject:option.title];
    }
    [self wrong:model.modelID options:options];
    
    if (![self decreaseScore]) {
        if (self.maxGroupNum == self.models.count &&
            self.gameScene.curIndex == self.models.count - 1) {
            [self.gameScene finishAll];
        }
        else {
            [self next];
        }
    }
}

@end
