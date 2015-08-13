//
//  DDPHttpReqMgr.m
//  HappyStudy
//
//  Created by Q on 14/10/29.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "DDPHttpReqMgr.h"
#import "DDPMgr.h"
#import "DDPGroupModel.h"
#import "PinYinModel.h"
#import "HanZiModel.h"

@implementation DDPHttpReqMgr

#pragma mark - Override
+ (void)requestGetGameData:(NSString *)userName from:(NSInteger)fromPos count:(NSInteger)count completion:(HSHttpReqCompletion)completion failure:(HSHttpReqFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"StudentID"] = userName;
    params[@"GameID"] = [NSString stringWithFormat:@"%@", @(StudyGamePengPengShiZi - 1)];
    params[@"QuestionPos"] = [NSString stringWithFormat:@"%@", @(fromPos)];
    params[@"QuestionNumber"] = [NSString stringWithFormat:@"%@", @(count)];
    params[@"QuestionOrder"] = @"0";
    [[HttpReqMgr sharedInstance] requestWithMethod:@"getquestions"
                                            params:params
                                        completion:^(NSDictionary *info) {
                                            
                                            NSArray *array = info[@"Questions"];
                                            NSMutableArray *ddpModels = [DDPMgr sharedInstance].models;
                                            
                                            [DDPMgr sharedInstance].maxGroupNum = [info[@"TotalQuestionSize"] integerValue];
                                            NSInteger pos = [info[@"CurrentQuestionPos"] integerValue];
                                            [DDPMgr sharedInstance].curGroupCount = pos - array.count + 1;
                                            
                                            NSInteger lastIndex = 0;
                                            if (ddpModels.count > 0) {
                                                DDPGroupModel *lastModel = ddpModels.lastObject;
                                                lastIndex = [lastModel.indexStr integerValue];
                                            }
                                            NSInteger index = array.count - 1;
                                            for (int i = 0; i < array.count; i++) {
                                                NSDictionary *dict = array[index];
                                                NSArray *group = dict[@"Question"];
                                                DDPGroupModel *gModel = [[DDPGroupModel alloc] init];
                                                gModel.indexStr = [NSString stringWithFormat:@"%@", @(pos + 1 + i)];
                                                gModel.modelID = [dict[@"QuestionsID"] integerValue];
                                                for (int j = 0; j < group.count; j++) {
                                                    NSDictionary *modelInfo = group[j];
                                                    NSString *matchKey = [NSString stringWithFormat:@"%@_%@",
                                                                          modelInfo[@"pinyin"],
                                                                          modelInfo[@"word"]];
                                                    
                                                    PinYinModel *pyModel = [[PinYinModel alloc] init];
                                                    pyModel.title = modelInfo[@"pinyin"];
                                                    pyModel.soundName = modelInfo[@"audio_path"];
                                                    pyModel.matchKey = matchKey;
                                                    [gModel.pyModels addObject:pyModel];
                                                    
                                                    HanZiModel *hzModel = [[HanZiModel alloc] init];
                                                    hzModel.title = modelInfo[@"word"];
                                                    hzModel.matchKey = matchKey;
                                                    hzModel.soundName = pyModel.soundName;
                                                    [gModel.hzModels addObject:hzModel];
                                                }
                                                
                                                [ddpModels addObject:gModel];
                                                
                                                index--;
                                            }
                                            
                                            if (completion) {
                                                completion(info);
                                            }
                                        } failure:^(HSError *error) {
                                            if (failure) {
                                                failure(error);
                                            }
                                        }];
}

@end
