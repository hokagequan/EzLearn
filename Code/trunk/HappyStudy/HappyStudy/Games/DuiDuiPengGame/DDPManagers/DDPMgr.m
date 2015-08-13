//
//  DDPManagers.m
//  HappyStudy
//
//  Created by Quan on 14/10/22.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "DDPMgr.h"
#import "DDPGroupModel.h"
#import "PinYinModel.h"
#import "HanZiModel.h"
#import "HttpReqMgr.h"
#import "AccountMgr.h"
#import "GameMgr.h"

@implementation DDPMgr

+ (instancetype)sharedInstance {
    static DDPMgr *_sharedDDPMgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDDPMgr = [[self alloc] init];
    });
    
    return _sharedDDPMgr;
}

- (id)init {
    if (self = [super init]) {
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
            [gModel.hzModels addObject:hzModel];
        }
        
        [models addObject:gModel];
        
        index--;
    }
}

#pragma mark - 碰碰识字
- (void)loadPengPengShiZiIndividualServerGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure {
    [self.models removeAllObjects];
    
    [HttpReqMgr requestIndividualGetGameData:[AccountMgr sharedInstance].user.name
                                      gameID:StudyGamePengPengShiZi
                                       level:[GameMgr sharedInstance].level
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

- (void)loadPengPengShiZiIndividualServerMoreGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure {
    [HttpReqMgr requestIndividualGetGameData:[AccountMgr sharedInstance].user.name
                                      gameID:StudyGamePengPengShiZi
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

- (void)loadPengPengShiZiLocalGameData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PengPengShiZi" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *key = [GlobalUtil levelKeyWith:[GameMgr sharedInstance].level];
    NSArray *questions = dict[key];
    
    self.maxGroupNum = questions.count;
    self.curGroupCount = 0;
    
    for (int i = 0; i < questions.count; i++) {
        NSDictionary *dict = questions[i];
        NSArray *group = dict[@"question"];
        DDPGroupModel *gModel = [[DDPGroupModel alloc] init];
        gModel.indexStr = [NSString stringWithFormat:@"%@", @(i)];
        gModel.modelID = i;
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
            [gModel.hzModels addObject:hzModel];
        }
        
        [self.models addObject:gModel];
    }
}

#pragma mark - 碰碰搭词
- (void)loadPengPengDaCiServerGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure {
    [self.models removeAllObjects];
    
    [HttpReqMgr requestGetGameData:[AccountMgr sharedInstance].user.name
                            gameID:StudyGamePengPengDaCi
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

- (void)loadPengPengDaCiServerMoreGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure {
    [HttpReqMgr requestGetGameData:[AccountMgr sharedInstance].user.name
                            gameID:StudyGamePengPengDaCi
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

@end
