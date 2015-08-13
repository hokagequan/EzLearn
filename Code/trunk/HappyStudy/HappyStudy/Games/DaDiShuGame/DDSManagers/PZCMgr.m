//
//  PZCMgr.m
//  EasyLSP
//
//  Created by Quan on 15/6/16.
//  Copyright © 2015年 LittleIsland. All rights reserved.
//

#import "PZCMgr.h"
#import "PinZiChuiScene.h"
#import "SKNode+PlaySound.h"
#import "DDSModel.h"
#import "GameMgr.h"

@implementation PZCMgr

- (void)appendDataWithInfo:(NSDictionary *)info {
    NSArray *array = info[@"Questions"];
    NSMutableArray *models = self.models;
    
    self.maxGroupNum = [info[@"TotalQuestionSize"] integerValue];
    if ([GameMgr sharedInstance].gameGroup == GroupIndividual) {
        self.maxGroupNum = [info[@"ReturnQestionNum"] integerValue];
    }
    NSInteger pos = [info[@"CurrentQuestionPos"] integerValue];
    self.curGroupCount = pos - array.count + 1;
    
    NSInteger index = array.count - 1;
    for (int i = 0; i < array.count; i++) {
        NSDictionary *dict = array[index];
        NSDictionary *group = dict[@"Question"];
        DDSModel *model = [[DDSModel alloc] init];
        model.modelID = dict[@"QuestionsID"];
        model.indexStr = group[@"part"];
        DDSQuestion *qModel = [[DDSQuestion alloc] init];
        qModel.title = group[@"part"];
        qModel.sound = group[@"audio_path"];
        qModel.word = group[@"character"];
        model.question = qModel;
        NSArray *options = @[group[@"choiceA"], group[@"choiceB"], group[@"choiceC"], group[@"choiceD"]];
        NSInteger answer = [group[@"answer"] integerValue];
        for (int i = 0; i < options.count; i++) {
            DDSOption *oModel = [[DDSOption alloc] init];
            oModel.title = options[i];
            oModel.isAnswer = (i + 1) == answer;
            [model.options addObject:oModel];
        }
        
        [models addObject:model];
        
        index--;
    }
}

- (void)correct {
    DDSModel *model = self.models[self.gameScene.curIndex];
    [self.gameScene playSound:model.question.sound completion:^{
        
    }];
    
    [super correct];
}

@end
