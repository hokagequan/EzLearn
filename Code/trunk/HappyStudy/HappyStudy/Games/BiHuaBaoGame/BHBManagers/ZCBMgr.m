//
//  ZCBMgr.m
//  EasyLSP
//
//  Created by Q on 15/6/23.
//  Copyright © 2015年 LittleIsland. All rights reserved.
//

#import "ZCBMgr.h"
#import "BHBModel.h"
#import "GameMgr.h"

#define TOTAL_TIME 20.0

@implementation ZCBMgr

- (instancetype)init {
    if (self = [super init]) {
        self.totalTime = TOTAL_TIME;
    }
    
    return self;
}

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
        BHBModel *model = [[BHBModel alloc] init];
        model.modelID = dict[@"QuestionsID"];
        model.indexStr = [NSString stringWithFormat:@"%@", @(pos + 1 + i)];
        
        BHBQuestion *qModel = [[BHBQuestion alloc] init];
        qModel.title = [NSString stringWithFormat:@"%@", group[@"character"]];
        model.question = qModel;
        
        NSArray *options = group[@"choices"];
        for (int j = 0; j < options.count; j++) {
            NSDictionary *dict = options[j];
            BHBOption *oModel = [[BHBOption alloc] init];
            oModel.title = dict[@"word"];
            oModel.sound = dict[@"audio_path"];
            oModel.isAnswer = [dict[@"correct"] boolValue];
            oModel.order = [dict[@"direct"] integerValue];
            [model.options addObject:oModel];
        }
        
        [models addObject:model];
        
        index--;
    }
}

@end
