//
//  PZKMgr.m
//  EasyLSP
//
//  Created by Q on 15/6/16.
//  Copyright © 2015年 LittleIsland. All rights reserved.
//

#import "PZKMgr.h"
#import "ZiMuKuangScene.h"
#import "ZMKModel.h"
#import "ZMKOption.h"
#import "SKNode+PlaySound.h"
#import "GameMgr.h"

@interface PZKMgr()

@property (nonatomic) NSInteger optionIndex;

@end

@implementation PZKMgr

- (NSString *)characterInFruit {
    ZMKModel *model = self.models[self.gameScene.curIndex];
    if (self.optionIndex < model.options.count) {
        ZMKOption *option = model.options[self.optionIndex];

        return option.title;
    }
    
    return nil;
}

- (void)checkNode:(HSLabelSprite *)nodeA with:(HSLabelSprite *)nodeB {
    ZMKModel *model = self.models[self.gameScene.curIndex];
    ZMKOption *option = model.options[self.optionIndex];
    
    if (option.isAnswer) {
        [self correct];
    }
    else {
        [self wrong];
    }
}

- (void)correct {
    self.clickCount++;
    ZMKModel *model = self.models[self.gameScene.curIndex];
    NSMutableArray *options = [NSMutableArray array];
    for (ZMKOption *option in model.options) {
        [options addObject:option.title];
    }
    [self correct:model.modelID options:options];
    
    self.score++;
    self.life++;
    self.correctCount++;
    [self.gameScene refreshScore:self.score];
    [self.gameScene changeLifeWith:self.life];
    
    self.basketFruitNumber++;
    
    ZMKOption *option = model.options[self.optionIndex];
    
    [self.gameScene playSound:option.sound completion:^{
        [self.gameScene playCorrectMaleSound];
    }];
}

- (void)gameStart {
    [super gameStart];
    
    self.optionIndex = 0;
}

- (void)gameLogic:(NSTimeInterval)interval {
    if (self.stat != ZMKGameStatStart) {
        return;
    }
    
    if (![self.gameScene isFruitDropping]) {
        if (self.basketFruitNumber >= ZMK_PASS_COUNT) {
            self.basketFruitNumber = 0;
            if (self.gameScene.curIndex == self.models.count - 1) {
                if (self.maxGroupNum != self.models.count) {
                    [self.gameScene clickRight:nil];
                }
                else {
                    [self.gameScene finishAll];
                }
            }
            else {
                [self goNext];
            }
        }
        else {
            if (self.gameScene.curIndex >= self.models.count) {
                return;
            }
            
            ZMKModel *model = self.models[self.gameScene.curIndex];
            self.optionIndex++;
            
            CGFloat duration = ORIGINAL_DROPPING_TIME;
            if ([GameMgr sharedInstance].gameGroup == GroupIndividual) {
                duration = [self caculateStayTimeWith:self.correctCount];
            }
            if (self.optionIndex < model.options.count) {
                [self.gameScene dropFruitFrom:[self randomPosition]
                                         text:[self characterInFruit]
                                     duration:duration];
            }
            else {
                self.optionIndex = 0;
                [self.gameScene addCharacters:self.gameScene.curIndex];
            }
        }
    }
}

@end
