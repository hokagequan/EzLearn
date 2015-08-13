//
//  PZBMgr.m
//  EasyLSP
//
//  Created by Quan on 15/6/17.
//  Copyright © 2015年 LittleIsland. All rights reserved.
//

#import "PZBMgr.h"
#import "GameMgr.h"

@implementation PZBMgr

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
        CGChooseModel *cModel = [[CGChooseModel alloc] init];
        cModel.modelID = [dict[@"QuestionsID"] integerValue];
        cModel.indexStr = group[@"part"];
        CGQuestionModel *qModel = [[CGQuestionModel alloc] init];
        qModel.title = group[@"part"];
        qModel.soundName = group[@"audio_path"];
        qModel.word = group[@"character"];
        cModel.question = qModel;
        NSArray *options = @[group[@"choiceA"], group[@"choiceB"], group[@"choiceC"], group[@"choiceD"]];
        NSInteger answer = [group[@"answer"] integerValue];
        for (int i = 0; i < options.count; i++) {
            CGOptionModel *oModel = [[CGOptionModel alloc] init];
            oModel.title = options[i];
            oModel.isAnswer = (i + 1) == answer;
            [cModel.options addObject:oModel];
        }
        
        [models addObject:cModel];
        
        index--;
    }
}

@end
