//
//  DDSMgr.m
//  EasyLSP
//
//  Created by Quan on 15/5/7.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "BHBMgr.h"
#import "AccountMgr.h"
#import "BHBModel.h"
#import "BHBOption.h"
#import "HttpReqMgr.h"
#import "GameMgr.h"

#import "BiHuaBaoScene.h"

#define TOTAL_TIME 45.0

@interface BHBMgr()

@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) CGFloat leftTime;

@end

@implementation BHBMgr

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
        qModel.title = [NSString stringWithFormat:@"%@", group[@"strokeNo"]];
        model.question = qModel;
        
        NSArray *options = group[@"choices"];
        for (int j = 0; j < options.count; j++) {
            NSDictionary *dict = options[j];
            BHBOption *oModel = [[BHBOption alloc] init];
            oModel.title = dict[@"word"];
            oModel.sound = dict[@"audio_path"];
            oModel.strokeNo = [NSString stringWithFormat:@"%@", dict[@"strokeNo"]];
            oModel.isAnswer = [qModel.title isEqualToString:oModel.strokeNo];
            [model.options addObject:oModel];
        }
        
        [models addObject:model];
        
        index--;
    }
}

- (void)correct {
    self.clickCount++;
    BHBModel *model = self.models[self.gameScene.curIndex];
    NSMutableArray *options = [NSMutableArray array];
    for (BHBOption *option in model.options) {
        [options addObject:option.title];
    }
    [self correct:model.modelID options:options];
    
    self.score++;
    [self.gameScene refreshScore:self.score];
    if (self.gameScene.curIndex == self.models.count - 1) {
        if (self.maxGroupNum != self.models.count) {
            [self.gameScene clickRight:nil];
        }
        else {
            [self.gameScene finishAll];
        }
        
    }
    else {
        self.gameScene.userInteractionEnabled = NO;
        [self performSelector:@selector(next) withObject:nil afterDelay:GAME_INTERVAL];
    }
}

- (void)countingDown {
    self.leftTime--;
    [self.gameScene refreshTime:self.leftTime];
    
    if (self.leftTime <= 0) {
        [self.timer invalidate];
        self.timer = nil;
        
        [self wrong];
    }
}

- (void)clean {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)decreaseScore {
    self.score--;
    if (self.score < 0) {
        self.score = 0;
    }
}

- (void)gameStart {
    self.leftTime = self.totalTime;
    self.stat = BHBGameStatStart;
    [self.gameScene refreshTime:self.leftTime];
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
        
        [self gameOver];
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(countingDown)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)gameEnd {
    self.stat = BHBGameStatEnd;
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)gameOver {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    [self.gameScene gameOver];
}

- (void)gameLogic:(NSTimeInterval)interval {}

- (void)next {
    self.gameScene.userInteractionEnabled = YES;
    [self reloadTimer];
    self.gameScene.curIndex++;
}

- (void)reloadTimer {
    self.leftTime = self.totalTime;
    [self.gameScene refreshTime:self.leftTime];
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(countingDown)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)wrong {
    if (self.gameScene.curIndex >= self.models.count) {
        return;
    }
    
    self.clickCount++;
    BHBModel *model = self.models[self.gameScene.curIndex];
    NSMutableArray *options = [NSMutableArray array];
    for (BHBOption *option in model.options) {
        [options addObject:option.title];
    }
    [self wrong:model.modelID options:options];
    
    [self decreaseScore];
    [self.gameScene refreshScore:self.score];
    
    if (self.gameScene.curIndex == self.models.count - 1) {
        if (self.curGroupCount > 0) {
            [self.gameScene clickRight:nil];
        }
        else {
            [self.gameScene finishAll];
        }
        
    }
    else {
        self.gameScene.userInteractionEnabled = NO;
        [self performSelector:@selector(next) withObject:nil afterDelay:GAME_INTERVAL];
    }
}

#pragma mark - 笔画宝
- (void)loadServerGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure {
    [self.models removeAllObjects];
    
    [HttpReqMgr requestGetGameData:[AccountMgr sharedInstance].user.name
                            gameID:StudyGameBiHuaBao
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
                            gameID:StudyGameBiHuaBao
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

- (void)loadServerIndividualGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure {
    [self.models removeAllObjects];
    
    [HttpReqMgr requestIndividualGetGameData:[AccountMgr sharedInstance].user.name
                                      gameID:StudyGameBiHuaBao
                                       level:[GameMgr sharedInstance].level
                                        from:-1
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

- (void)loadServerIndividualMoreGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure {
    [HttpReqMgr requestIndividualGetGameData:[AccountMgr sharedInstance].user.name
                                      gameID:StudyGameBiHuaBao
                                       level:[GameMgr sharedInstance].level
                                        from:self.models.count
                                       count:1000
                                  completion:^(NSDictionary *info) {
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
    NSString *path = [[NSBundle mainBundle] pathForResource:@"BiHuaBao" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *key = [GlobalUtil levelKeyWith:[GameMgr sharedInstance].level];
    NSArray *questions = dict[key];
    
    self.maxGroupNum = questions.count;
    self.curGroupCount = 0;
    
    for (int i = 0; i < questions.count; i++) {
        NSDictionary *detail = questions[i];
        
        BHBModel *model = [[BHBModel alloc] init];
        model.modelID = [NSString stringWithFormat:@"%ld", (long)i];
        model.indexStr = model.modelID;
        
        BHBQuestion *question = [[BHBQuestion alloc] init];
        question.title = detail[@"question"];
        model.question = question;
        
        NSArray *options = detail[@"options"];
        for (int j = 0; j < options.count; j++) {
            NSDictionary *optionInfo = options[j];
            BHBOption *option = [[BHBOption alloc] init];
            option.title = optionInfo[@"word"];
            option.sound = optionInfo[@"sound"];
            option.strokeNo = optionInfo[@"bihua"];
            
            [model.options addObject:option];
        }
        
        [self.models addObject:model];
    }
}

#pragma mark - 组词宝
- (void)loadZuCiBaoServerGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure {
    [self.models removeAllObjects];
    
    [HttpReqMgr requestGetGameData:[AccountMgr sharedInstance].user.name
                            gameID:StudyGameZuCiBao
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

- (void)loadZuCiBaoServerMoreGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure {
    [HttpReqMgr requestGetGameData:[AccountMgr sharedInstance].user.name
                            gameID:StudyGameZuCiBao
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

- (void)loadZuCiBaoIndividualServerGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure {
    [self.models removeAllObjects];
    
    [HttpReqMgr requestIndividualGetGameData:[AccountMgr sharedInstance].user.name
                                      gameID:StudyGameZuCiBao
                                       level:[GameMgr sharedInstance].level
                                        from:-1
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

- (void)loadZuCiBaoIndividualServerMoreGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure {
    [HttpReqMgr requestIndividualGetGameData:[AccountMgr sharedInstance].user.name
                                      gameID:StudyGameZuCiBao
                                       level:[GameMgr sharedInstance].level
                                        from:-1
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

- (void)loadZuCiBaoLocalGameData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ZuCiBao" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *key = [GlobalUtil levelKeyWith:[GameMgr sharedInstance].level];
    NSArray *questions = dict[key];
    
    self.maxGroupNum = questions.count;
    self.curGroupCount = 0;
    
    for (int i = 0; i < questions.count; i++) {
        NSDictionary *detail = questions[i];
        
        BHBModel *model = [[BHBModel alloc] init];
        model.modelID = [NSString stringWithFormat:@"%ld", (long)i];
        model.indexStr = model.modelID;
        
        BHBQuestion *question = [[BHBQuestion alloc] init];
        question.title = detail[@"question"];
        question.sound = detail[@"sound"];
        model.question = question;
        
        NSArray *options = detail[@"options"];
        for (int j = 0; j < options.count; j++) {
            NSDictionary *optionInfo = options[j];
            BHBOption *option = [[BHBOption alloc] init];
            option.title = optionInfo[@"title"];
            option.sound = optionInfo[@"sound"];
            option.isAnswer = [optionInfo[@"isAnswer"] boolValue];
            option.order = [optionInfo[@"order"] integerValue];
            
            [model.options addObject:option];
        }
        
        [self.models addObject:model];
    }
}

@end
