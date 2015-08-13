//
//  ZMKIndividualMgr.m
//  EasyLSP
//
//  Created by Quan on 15/5/26.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "ZMKIndividualMgr.h"
#import "ZiMuKuangScene.h"
#import "ZMKModel.h"
#import "ZMKOption.h"

@implementation ZMKIndividualMgr

- (void)wrong {
    [self.gameScene playWrongSound];
    
    self.clickCount++;
    ZMKModel *model = self.models[self.gameScene.curIndex];
    NSMutableArray *options = [NSMutableArray array];
    for (ZMKOption *option in model.options) {
        [options addObject:option.title];
    }
    [self wrong:model.modelID options:options];
    
    self.score--;
    self.life--;
    if (self.score <= 0) {
        self.score = 0;
    }
    if (self.life <= 0) {
        self.life = 0;
        
        [self gameEnd];
        [self.gameScene gameOver];
        
        return;
    }
    [self.gameScene refreshScore:self.score];
    [self.gameScene changeLifeWith:self.life];
    
    self.basketFruitNumber--;
    if (self.basketFruitNumber < 0) {
        self.basketFruitNumber = 0;
    }
}

@end
