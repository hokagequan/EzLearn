//
//  DDSIndividualMgr.m
//  EasyLSP
//
//  Created by Q on 15/5/25.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "DDSIndividualMgr.h"
#import "DaDiShuScene.h"
#import "DDSModel.h"
#import "DDSOption.h"

@implementation DDSIndividualMgr

#pragma mark - Override
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
    DDSModel *model = self.models[self.gameScene.curIndex];
    NSMutableArray *options = [NSMutableArray array];
    for (DDSOption *option in model.options) {
        [options addObject:option.title];
    }
    [self wrong:model.modelID questions:nil options:options];
    
    if (![self decreaseScore]) {
        if (self.maxGroupNum == self.models.count &&
            self.gameScene.curIndex == self.models.count - 1) {
            [self.gameScene finishAll];
        }
        else {
            [self goNext];
        }
    }
}

@end
