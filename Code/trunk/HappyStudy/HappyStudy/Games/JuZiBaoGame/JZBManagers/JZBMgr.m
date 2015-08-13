//
//  DDSMgr.m
//  EasyLSP
//
//  Created by Quan on 15/5/7.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "JZBMgr.h"
#import "AccountMgr.h"
#import "GameMgr.h"
#import "JZBModel.h"
#import "JZBOption.h"
#import "HttpReqMgr.h"

#import "JuZiBaoScene.h"

#import <AVFoundation/AVFoundation.h>

@interface JZBMgr()<AVSpeechSynthesizerDelegate>

@end

@implementation JZBMgr

- (instancetype)init {
    if (self = [super init]) {
        self.stat = JZBStatNon;
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
        JZBModel *model = [[JZBModel alloc] init];
        model.modelID = dict[@"QuestionsID"];
        model.indexStr = [NSString stringWithFormat:@"%@", @(pos + 1 - i)];
        JZBQuestion *qModel = [[JZBQuestion alloc] init];
        NSArray *titles = group[@"words"];
        for (int j = 0; j < titles.count; j++) {
            if (j >= 3) {
                NSString *title = qModel.titles[2];
                title = [title stringByAppendingString:titles[j][@"word"]];
                qModel.titles[2] = title;
                
                continue;
            }
            [qModel.titles addObject:titles[j][@"word"]];
        }
        qModel.questionIndex = [group[@"Miss_position"] integerValue];
        qModel.questionIndex = qModel.questionIndex > 3 ? 3 : qModel.questionIndex;
        model.question = qModel;
        
        NSArray *options = @[group[@"choiceA"], group[@"choiceB"], group[@"choiceC"], group[@"choiceD"]];
        NSInteger answer = 0;
        if (![group[@"answer"] isEqual:[NSNull null]]) {
            answer = [group[@"answer"] integerValue];
        }
        for (int i = 0; i < options.count; i++) {
            JZBOption *oModel = [[JZBOption alloc] init];
            
            if ([options[i] isEqual:[NSNull null]]) {
                oModel.title = @"";
            }
            else {
                oModel.title = options[i];
            }
            
            oModel.isAnswer = (i + 1) == answer;
            [model.options addObject:oModel];
        }
        
        [models addObject:model];
        
        index--;
    }
}

- (void)correct {
    [self.gameScene frogHappy];
    [self.gameScene playCorrectMaleSound];
    
    self.clickCount++;
    JZBModel *model = self.models[self.gameScene.curIndex];
    
    NSMutableArray *options = [NSMutableArray array];
    for (JZBOption *option in model.options) {
        [options addObject:option.title];
    }
    [self correct:model.modelID options:options];
    
    self.score++;
    [self.gameScene refreshScore:self.score];
}

- (void)gameLogic:(NSTimeInterval)interval {
    if (self.stat == JZBStatStartChecking) {
        self.gameScene.isFrogAnimationFinish = NO;
        if (self.isAnswer) {
            self.gameScene.isSpeakingFinish = NO;
            JZBModel *model = self.models[self.gameScene.curIndex];
            AVSpeechSynthesizer *synth = [GlobalUtil speakText:[model combineSentence]];
            synth.delegate = self;
            [self.gameScene setFrogJumpTarget:3];
        }
        else {
            [self.gameScene setFrogJumpTarget:self.questionIndex];
        }
        
        self.stat = JZBStatDoChecking;
    }
    else if (self.stat == JZBStatDoChecking) {
        [self.gameScene frogJump];
    }
    else if (self.stat == JZBStatDoCheckResult) {
        if (self.isAnswer) {
            [self correct];
        }
        else {
            [self wrong];
        }
        
        self.stat = JZBStatNon;
    }
}

- (void)reloadStat {
    self.stat = JZBStatNon;
}

- (void)wrong {
    [self.gameScene playWrongSound];
    
    self.clickCount++;
    JZBModel *model = self.models[self.gameScene.curIndex];
    NSMutableArray *options = [NSMutableArray array];
    for (JZBOption *option in model.options) {
        [options addObject:option.title];
    }
    [self wrong:model.modelID options:options];
    
    self.score--;
    if (self.score < 0) {
        self.score = 0;
    }
    
    [self.gameScene refreshScore:self.score];
    [self.gameScene frogFallDown];
}

#pragma mark - AVSpeech
- (void)speechSynthesizer:(nonnull AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(nonnull AVSpeechUtterance *)utterance {
    if (self.gameScene.curIndex == self.models.count - 1) {
        if (self.maxGroupNum != self.models.count) {
            self.gameScene.isSpeakingFinish = YES;
            [self.gameScene clickRight:nil];
        }
        else {
            [self.gameScene finishAll];
        }
        
    }
    else {
        self.gameScene.isSpeakingFinish = YES;
        [self.gameScene checkShouldGoNext];
    }
}

#pragma mark - 句子宝
- (void)loadServerGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure {
    [self.models removeAllObjects];
    
    [HttpReqMgr requestGetGameData:[AccountMgr sharedInstance].user.name
                            gameID:StudyGameJuZiBao
                              from:0
                             count:1000
                        completion:^(NSDictionary *info) {
                            [self appendDataWithInfo:info];
                            
                            if (self.models.count == 0) {
                                if (failure) {
                                    HSError *error = [HSError errorWith:HSHttpErrorCodeNoData];
                                    failure(@{@"error": error});
                                }
                            }
                            else {
                                if (completion) {
                                    completion();
                                }
                            }
                        } failure:^(HSError *error) {
                            if (failure) {
                                failure(@{@"error": error});
                            }
                        }];
}

- (void)loadServerMoreGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure {
    [HttpReqMgr requestGetGameData:[AccountMgr sharedInstance].user.name
                            gameID:StudyGameJuZiBao
                              from:self.models.count
                             count:1000
                        completion:^(NSDictionary *info) {
                            [self appendDataWithInfo:info];
                            if (completion) {
                                completion();
                            }
                        } failure:^(HSError *error) {
                            if (failure) {
                                failure(@{@"error": error});
                            }
                        }];
}

- (void)loadIndividualServerGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure {
    [self.models removeAllObjects];
    
    [HttpReqMgr requestIndividualGetGameData:[AccountMgr sharedInstance].user.name
                                      gameID:StudyGameJuZiBao
                                       level:[GameMgr sharedInstance].level
                                        from:self.models.count
                                       count:1000
                                  completion:^(NSDictionary *info) {
                                      [self appendDataWithInfo:info];
                                      
                                      if (self.models.count == 0) {
                                          if (failure) {
                                              HSError *error = [HSError errorWith:HSHttpErrorCodeNoData];
                                              failure(@{@"error": error});
                                          }
                                      }
                                      else {
                                          if (completion) {
                                              completion();
                                          }
                                      }
                                  } failure:^(HSError *error) {
                                      if (failure) {
                                          failure(@{@"error": error});
                                      }
                                  }];
}

- (void)loadIndividualServerMoreGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure {
    [HttpReqMgr requestIndividualGetGameData:[AccountMgr sharedInstance].user.name
                                      gameID:StudyGameJuZiBao
                                       level:[GameMgr sharedInstance].level
                                        from:self.models.count
                                       count:1000
                                  completion:^(NSDictionary *info) {
                                      [self appendDataWithInfo:info];
                                      if (completion) {
                                          completion();
                                      }
                                  } failure:^(HSError *error) {
                                      if (failure) {
                                          failure(@{@"error": error});
                                      }
                                  }];
}

- (void)loadLocalGameData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"JuZiBao" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *key = [GlobalUtil levelKeyWith:[GameMgr sharedInstance].level];
    NSArray *questions = dict[key];
    
    self.maxGroupNum = questions.count;
    self.curGroupCount = 0;
    
    for (int i = 0; i < questions.count; i++) {
        NSDictionary *detail = questions[i];
    
        JZBModel *model = [[JZBModel alloc] init];
        model.modelID = [NSString stringWithFormat:@"%ld", (long)i];
        model.indexStr = model.modelID;
        
        JZBQuestion *question = [[JZBQuestion alloc] init];
        question.titles = [detail[@"titles"] mutableCopy];
        question.questionIndex = [detail[@"questionIndex"] integerValue];
        model.question = question;
        
        NSArray *options = detail[@"options"];
        NSInteger answer = [detail[@"answer"] integerValue];
            
        for (int j = 0; j < options.count; j++) {
            JZBOption *option = [[JZBOption alloc] init];
            option.title = options[j];
            option.isAnswer = (j + 1) == answer;
            
            [model.options addObject:option];
        }
        
        [self.models addObject:model];
    }
}

@end
