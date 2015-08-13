//
//  CGHttpReqMgr.m
//  HappyStudy
//
//  Created by Q on 14/10/28.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "CGHttpReqMgr.h"
#import "CGMgr.h"

@implementation CGHttpReqMgr

#pragma mark - Override
+ (void)requestGetGameData:(NSString *)userName from:(NSInteger)fromPos count:(NSInteger)count completion:(HSHttpReqCompletion)completion failure:(HSHttpReqFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"StudentID"] = userName;
    params[@"GameID"] = [NSString stringWithFormat:@"%@", @(StudyGameTingYinShiZi - 1)];
    params[@"QuestionPos"] = [NSString stringWithFormat:@"%@", @(fromPos)];
    params[@"QuestionNumber"] = [NSString stringWithFormat:@"%@", @(count)];
    params[@"QuestionOrder"] = @"0";
    [[HttpReqMgr sharedInstance] requestWithMethod:@"getquestions"
                                            params:params
                                        completion:^(NSDictionary *info) {
                                            NSArray *array = info[@"Questions"];
                                            NSMutableArray *cgModels = [CGMgr sharedInstance].models;
                                            
                                            [CGMgr sharedInstance].maxGroupNum = [info[@"TotalQuestionSize"] integerValue];
                                            NSInteger pos = [info[@"CurrentQuestionPos"] integerValue];
                                            [CGMgr sharedInstance].curGroupCount = pos - array.count + 1;
                                            
                                            NSInteger index = array.count - 1;
                                            for (int i = 0; i < array.count; i++) {
                                                NSDictionary *dict = array[index];
                                                NSDictionary *group = dict[@"Question"];
                                                CGChooseModel *cModel = [[CGChooseModel alloc] init];
                                                cModel.modelID = [dict[@"QuestionsID"] integerValue];
                                                cModel.indexStr = group[@"pinyin"];
                                                CGQuestionModel *qModel = [[CGQuestionModel alloc] init];
                                                qModel.title = group[@"pinyin"];
                                                qModel.soundName = group[@"audio_path"];
                                                cModel.question = qModel;
                                                NSArray *options = @[group[@"choiceA"], group[@"choiceB"], group[@"choiceC"], group[@"choiceD"]];
                                                NSInteger answer = [group[@"answer"] integerValue];
                                                for (int i = 0; i < options.count; i++) {
                                                    CGOptionModel *oModel = [[CGOptionModel alloc] init];
                                                    oModel.title = options[i];
                                                    oModel.isAnswer = (i + 1) == answer;
                                                    [cModel.options addObject:oModel];
                                                }
                                                
                                                [cgModels addObject:cModel];
                                                
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
