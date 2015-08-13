//
//  CGMgr.m
//  HappyStudy
//
//  Created by Q on 14-10-15.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "CGMgr.h"
#import "CGChooseModel.h"
#import "HttpReqMgr.h"
#import "AccountMgr.h"
#import "GameMgr.h"

@implementation CGMgr

+ (instancetype)sharedInstance {
    static CGMgr *_sharedCGMgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedCGMgr = [[self alloc] init];
    });
    
    return _sharedCGMgr;
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
        
        [models addObject:cModel];
        
        index--;
    }
}

#pragma mark - Class Function
+ (NSMutableArray *)fourOptionsWithStandard:(NSString *)standard source:(NSArray *)source {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:4];
    CGOptionModel *model = [[CGOptionModel alloc] init];
    model.title = standard;
    model.isAnswer = YES;
    [array addObject:model];
    
    while (array.count < 4) {
        NSUInteger random = [GlobalUtil randomIntegerWithMax:source.count];
        if (![source[random][@"title"] isEqualToString:standard]) {
            CGOptionModel *randomModel = [[CGOptionModel alloc] init];
            randomModel.title = source[random][@"title"];
            randomModel.isAnswer = NO;
            [array addObject:randomModel];
        }
    }
    
    [GlobalUtil randomArray:array];
    
    return array;
}

#pragma mark - 字母宝
+ (void)loadLocalGameDataZiMuBaoWithSource:(NSArray *)source {
    [[CGMgr sharedInstance].models removeAllObjects];
    
    for (int i = 0; i < source.count; i++) {
        NSDictionary *dict = source[i];
        CGChooseModel *model = [[CGChooseModel alloc] init];
        CGQuestionModel *qModel = [[CGQuestionModel alloc] init];
        qModel.title = dict[@"title"];
        qModel.soundName = dict[@"sound"];
        model.indexStr = qModel.title;
        model.question = qModel;
        model.options = [self fourOptionsWithStandard:qModel.title source:source];
        [[CGMgr sharedInstance].models addObject:model];
    }
    
    [CGMgr sharedInstance].maxGroupNum = source.count;
}

+ (void)loadLocalGameDataZiMuBaoShengMu {
    [self loadLocalGameDataZiMuBaoWithSource:[GlobalUtil allShengMu]];
}

+ (void)loadLocalGameDataZiMuBaoYunMu {
    [self loadLocalGameDataZiMuBaoWithSource:[GlobalUtil allYunMu]];
}

+ (void)loadLocalGameDataZiMuBaoZhengTi {
    [self loadLocalGameDataZiMuBaoWithSource:[GlobalUtil allZhengTi]];
}

#pragma mark - 听音识字 
- (void)loadTingYinShiZiLocalGameData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"TingYinShiZi" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *key = [GlobalUtil levelKeyWith:[GameMgr sharedInstance].level];
    NSArray *questions = dict[key];
    
    self.maxGroupNum = questions.count;
    self.curGroupCount = 0;
    
    for (int i = 0; i < questions.count; i++) {
        NSDictionary *detail = questions[i];
        CGChooseModel *cModel = [[CGChooseModel alloc] init];
        cModel.modelID = i;
        cModel.indexStr = detail[@"question"];
        CGQuestionModel *qModel = [[CGQuestionModel alloc] init];
        qModel.title = detail[@"question"];
        qModel.soundName = detail[@"sound"];
        cModel.question = qModel;
        NSArray *options = detail[@"options"];
        NSInteger answer = [detail[@"anwser"] integerValue];
        for (int i = 0; i < options.count; i++) {
            CGOptionModel *oModel = [[CGOptionModel alloc] init];
            oModel.title = options[i];
            oModel.isAnswer = (i + 1) == answer;
            [cModel.options addObject:oModel];
        }
        
        [self.models addObject:cModel];
    }
}

- (void)loadTingYinShiZiIndividualGameDataFrom:(NSInteger)fromPos count:(NSInteger)count Complete:(void (^)(void))complete failure:(void (^)(NSDictionary *))failure {
    if (fromPos == 0) {
        [self.models removeAllObjects];
    }
    
    [HttpReqMgr requestIndividualGetGameData:[AccountMgr sharedInstance].user.name
                                      gameID:StudyGameTingYinShiZi
                                       level:[GameMgr sharedInstance].level
                                        from:fromPos
                                       count:count
                                  completion:^(NSDictionary *info) {
                                      [self appendDataWithInfo:info];
                                      
                                      if (self.models.count == 0) {
                                          if (failure) {
                                              HSError *error = [HSError errorWith:HSHttpErrorCodeNoData];
                                              failure(@{@"error": error});
                                          }
                                      }
                                      else {
                                          if (complete) {
                                              complete();
                                          }
                                      }
                                  } failure:^(HSError *error) {
                                      if (failure) {
                                          failure(@{@"error": error});
                                      }
                                  }];
}

#pragma mark - 拼字宝
- (void)loadPinZiBaoServerGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure {
    [self.models removeAllObjects];
    
    [HttpReqMgr requestGetGameData:[AccountMgr sharedInstance].user.name
                            gameID:StudyGamePinZiBao
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

- (void)loadPinZiBaoServerMoreGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure {
    [HttpReqMgr requestGetGameData:[AccountMgr sharedInstance].user.name
                            gameID:StudyGamePinZiBao
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

- (void)loadPinZiBaoIndividualServerGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure {
    [self.models removeAllObjects];
    
    [HttpReqMgr requestIndividualGetGameData:[AccountMgr sharedInstance].user.name
                                      gameID:StudyGamePinZiBao
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

- (void)loadPinZiBaoIndividualServerMoreGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure {
    [HttpReqMgr requestIndividualGetGameData:[AccountMgr sharedInstance].user.name
                                      gameID:StudyGamePinZiBao
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

- (void)loadPinZiBaoLocalGameData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PinZiBao" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *key = [GlobalUtil levelKeyWith:[GameMgr sharedInstance].level];
    NSArray *questions = dict[key];
    
    self.maxGroupNum = questions.count;
    self.curGroupCount = 0;
    self.maxGroupNum = questions.count;
    
    for (int i = 0; i < questions.count; i++) {
        NSDictionary *detail = questions[i];
        
        CGChooseModel *model = [[CGChooseModel alloc] init];
        model.modelID = i;
        model.indexStr = [NSString stringWithFormat:@"%ld", (long)i];
        
        CGQuestionModel *question = [[CGQuestionModel alloc] init];
        question.title = detail[@"question"];
        question.soundName = detail[@"sound"];
        question.word = detail[@"word"];
        model.question = question;
        
        NSInteger answer = [detail[@"answer"] integerValue];
        NSArray *options = detail[@"options"];
        
        for (int j = 0; j < options.count; j++) {
            CGOptionModel *option = [[CGOptionModel alloc] init];
            option.title = options[j];
            option.isAnswer = (j + 1) == answer;
            [model.options addObject:option];
        }
        
        [self.models addObject:model];
    }
}

@end
