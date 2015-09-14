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

- (instancetype)init {
    if (self = [super init]) {
        self.originalDroppingTime = 3.4;
    }
    
    return self;
}

- (void)appendDataWithInfo:(NSDictionary *)info {
    NSArray *array = info[@"Questions"];
    NSMutableArray *models = self.models;
    
    if ([GameMgr sharedInstance].gameGroup == GroupIndividual) {
        self.maxGroupNum = [info[@"ReturnQestionNum"] integerValue];
        self.curLevel = [info[@"DifficultLevel"] integerValue];
    }
    else {
        self.maxGroupNum = [info[@"TotalQuestionSize"] integerValue];
    }
    
    NSInteger pos = [info[@"CurrentQuestionPos"] integerValue];
    self.curGroupCount = pos - array.count + 1;
    
    NSInteger index = array.count - 1;
    for (int i = 0; i < array.count; i++) {
        NSDictionary *dict = array[index];
        NSDictionary *group = dict[@"Question"];
        ZMKModel *model = [[ZMKModel alloc] init];
        model.modelID = dict[@"QuestionsID"];
        model.indexStr = [NSString stringWithFormat:@"%@", @(pos + 1 + i)];
        ZMKQuestion *qModel = [[ZMKQuestion alloc] init];
        qModel.title = group[@"part"];
        model.question = qModel;
        
        NSArray *options = group[@"choices"];
        for (int j = 0; j < options.count; j++) {
            NSDictionary *detail = options[j];
            ZMKOption *option = [[ZMKOption alloc] init];
            option.title = detail[@"part"];
            option.sound = detail[@"audio_path"];
            option.isAnswer = [detail[@"correct"] boolValue];
            option.word = detail[@"character"];
            
            [model.options addObject:option];
        }
        
        [models addObject:model];
        
        index--;
    }
}

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
    ZMKModel *model = self.models[self.gameScene.curIndex];
    ZMKOption *option = model.options[self.optionIndex];
    
    [self.gameScene playSound:option.sound completion:^{
        [self.gameScene performSelector:@selector(playCorrectMaleSound) withObject:nil afterDelay:0.3];
    }];
    
    [self.gameScene showAnswer:option.word completion:nil];
    
    self.clickCount++;
    
    NSMutableArray *options = [NSMutableArray array];
    for (ZMKOption *option in model.options) {
        [options addObject:option.title];
    }
    [self correct:model.modelID questions:nil options:options];
    
    self.score++;
    self.life++;
    self.correctCount++;
    [self.gameScene refreshScore:self.score];
    [self.gameScene changeLifeWith:self.life];
    
    self.basketFruitNumber++;
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
            
            CGFloat duration = self.originalDroppingTime;
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
    else if ([self.gameScene.fruit.name isEqualToString:@"new"]) {
        if ([self isCurrentFruitCorrect] &&
            self.gameScene.fruit.position.y <= self.gameScene.fruit.size.height + [self deltaYZero]) {
            self.gameScene.fruit.name = @"old";
            SKAction *zoomOut = [SKAction scaleTo:1.5 duration:0.3];
            SKAction *zoomIn = [SKAction scaleTo:1.0 duration:0.3];
            [self.gameScene.fruit runAction:[SKAction sequence:@[zoomOut, zoomIn]]];
            
            [self wrong];
        }
    }
}

- (BOOL)isCurrentFruitCorrect {
    ZMKModel *model = self.models[self.gameScene.curIndex];
    ZMKOption *option = model.options[self.optionIndex];
    return option.isAnswer;
}

@end
