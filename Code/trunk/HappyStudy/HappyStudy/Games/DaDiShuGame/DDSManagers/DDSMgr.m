//
//  DDSMgr.m
//  EasyLSP
//
//  Created by Quan on 15/5/7.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "DDSMgr.h"
#import "AccountMgr.h"
#import "DDSModel.h"
#import "HttpReqMgr.h"
#import "GameMgr.h"

#import "DaDiShuScene.h"

#define MAX_WRONG_TIMES         3
#define ORIGINAL_STAY_TIME      3.0
#define MIN_STAY_TIME           2.0

typedef enum {
    GameStatStart = 1,
    GameStatReloadStat = 1 << 1,
}GameStat;

@interface DDSMgr()

@property (nonatomic) GameStat stat;

@property (nonatomic) CGFloat showTime;
@property (nonatomic) CGFloat stayTime;

@end

@implementation DDSMgr

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
        model.indexStr = group[@"pinyin"];
        DDSQuestion *qModel = [[DDSQuestion alloc] init];
        qModel.title = group[@"pinyin"];
        qModel.sound = group[@"audio_path"];
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

- (void)checkAnswerWith:(NSInteger)index {
    if (!(self.stat & GameStatStart)) {
        return;
    }
    
    self.stat |= GameStatReloadStat;
    
    if (self.gameScene.curIndex >= self.models.count) {
        return;
    }
    
    DDSModel *model = self.models[self.gameScene.curIndex];
    
    if (index >= model.options.count) {
        return;
    }
    
    DDSOption *option = model.options[index];
    
    if (option.isAnswer) {
        [self.gameScene changeCharacterStat:GopherStatSmile index:index];
        [self correct];
    }
    else {
        [self.gameScene changeCharacterStat:GopherStatCry index:index];
        [self wrong];
    }
}

- (void)correct {
    [self.gameScene playCorrectFemaleSound];
    
    self.clickCount++;
    DDSModel *model = self.models[self.gameScene.curIndex];
    NSMutableArray *options = [NSMutableArray array];
    for (DDSOption *option in model.options) {
        [options addObject:option.title];
    }
    [self correct:model.modelID options:options];
    
    self.score++;
    self.life++;
    
    [self.gameScene refreshScore:self.score];
    [self.gameScene changeLifeWith:self.life];
    
    if (self.gameScene.curIndex == self.models.count - 1) {
        if (self.maxGroupNum != self.models.count) {
            [self.gameScene clickRight:nil];
        }
        else {
            [self gameEnd];
            [self.gameScene finishAll];
        }
        
    }
    else {
        self.gameScene.userInteractionEnabled = NO;
        [self goNext];
    }
    
}

- (CGFloat)caculateStayTimeWith:(NSInteger)index {
    CGFloat time = ORIGINAL_STAY_TIME - 0.3 * (index - 1);
    
    return time >= MIN_STAY_TIME ? time : MIN_STAY_TIME;
}

- (BOOL)decreaseScore {
    self.life--;
    if (self.life < 0) {
        self.life = 0;
    }
    
    [self.gameScene changeLifeWith:self.life];
    
    return NO;
}

- (void)gameStart {
    self.stayTime = ORIGINAL_STAY_TIME;
    self.stat |= GameStatStart;
    
    self.score = 0;
    self.life = MAX_LIFE;
}

- (void)gameEnd {
    self.stat &= ~GameStatStart;
}

- (void)gameLogic:(CFTimeInterval)interval {
    if (!(self.stat & GameStatStart) || self.stat & GameStatReloadStat) {
        self.showTime = interval;
        self.stat &= ~GameStatReloadStat;
    }
    
    if (interval - self.showTime >= self.stayTime) {
        self.showTime = interval;
        self.missTimes++;
        
        if (self.missTimes >= MAX_WRONG_TIMES) {
            [self decreaseScore];
            
            if (self.maxGroupNum - 1 == self.gameScene.curIndex) {
                [self gameEnd];
                [self.gameScene finishAll];
            }
            else {
                self.gameScene.userInteractionEnabled = NO;
                [self goNext];
            }
        }
        else {
            [self.gameScene addCharacters:self.gameScene.curIndex];
        }
    }
}

- (void)goNext {
    self.gameScene.userInteractionEnabled = YES;
    self.stayTime = [self caculateStayTimeWith:self.gameScene.curIndex];
    [self performSelector:@selector(next) withObject:nil afterDelay:GAME_INTERVAL];
}

- (void)next {
    [self.gameScene next];
}

- (BOOL)isGameEnd {
    return !(self.stat & GameStatStart);
}

- (void)reShow {
    self.stayTime = [self caculateStayTimeWith:self.gameScene.curIndex];
    [self.gameScene addCharacters:self.gameScene.curIndex];
}

- (void)wrong {
    [self.gameScene playWrongSound];
    
    self.clickCount++;
    DDSModel *model = self.models[self.gameScene.curIndex];
    NSMutableArray *options = [NSMutableArray array];
    for (DDSOption *option in model.options) {
        [options addObject:option.title];
    }
    [self wrong:model.modelID options:options];
    
    if (![self decreaseScore]) {
        [self reShow];
    }
}

#pragma mark - 字母锤
- (void)loadServerGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure {
    [self.models removeAllObjects];
    
    [HttpReqMgr requestGetGameData:[AccountMgr sharedInstance].user.name
                            gameID:StudyGameZiMuChui
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
                            gameID:StudyGameZiMuChui
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
    NSArray *shengmu = [GlobalUtil allShengMu];
    NSArray *yunmu = [GlobalUtil allYunMu];
    NSArray *zhengti = [GlobalUtil allZhengTi];
    NSArray *standardCharacters = @[shengmu, yunmu, zhengti];
    NSMutableArray *totalCharacters = [@[[shengmu mutableCopy], [yunmu mutableCopy], [zhengti mutableCopy]] mutableCopy];
    
    NSInteger totalCount = shengmu.count + yunmu.count + zhengti.count;
    
    NSInteger index = 0;
    while (self.models.count < totalCount) {
        NSUInteger randomX = [GlobalUtil randomIntegerWithMax:totalCharacters.count];
        NSMutableArray *characters = totalCharacters[randomX];
        NSUInteger randomY = [GlobalUtil randomIntegerWithMax:characters.count];
        NSDictionary *characterInfo = characters[randomY];
        
        [characters removeObject:characterInfo];
        if (characters.count == 0) {
            [totalCharacters removeObjectAtIndex:randomX];
        }
        
        DDSModel *ddsModel = [[DDSModel alloc] init];
        ddsModel.modelID = [NSString stringWithFormat:@"%ld", (long)index];
        
        DDSQuestion *ddsQuestion = [[DDSQuestion alloc] init];
        ddsQuestion.title = characterInfo[@"title"];
        ddsQuestion.sound = characterInfo[@"sound"];
        ddsModel.question = ddsQuestion;
        
        DDSOption *ddsOption = [[DDSOption alloc] init];
        ddsOption.title = characterInfo[@"title"];
        ddsOption.isAnswer = YES;
        [ddsModel.options addObject:ddsOption];
        
        while (ddsModel.options.count < 4) {
            DDSOption *option = [[DDSOption alloc] init];
            NSUInteger randomNum = [GlobalUtil randomIntegerWithMax:[standardCharacters[randomX] count]];
            NSString *title = standardCharacters[randomX][randomNum][@"title"];
            if ([title isEqualToString:characterInfo[@"title"]]) {
                continue;
            }
            option.title = title;
            option.isAnswer = NO;
            [ddsModel.options addObject:option];
        }
        
        [GlobalUtil randomArray:ddsModel.options];
        [self.models addObject:ddsModel];
        
        index++;
    }
}

#pragma mark - 识字锤
- (void)loadShiZiChuiServerGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure {
    [self.models removeAllObjects];
    
    [HttpReqMgr requestGetGameData:[AccountMgr sharedInstance].user.name
                            gameID:StudyGameShiZiChui
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

- (void)loadShiZiChuiServerMoreGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure {
    [HttpReqMgr requestGetGameData:[AccountMgr sharedInstance].user.name
                            gameID:StudyGameShiZiChui
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

- (void)loadShiZiChuiServerIndividualGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure {
    [self.models removeAllObjects];
    
    [HttpReqMgr requestIndividualGetGameData:[AccountMgr sharedInstance].user.name
                                      gameID:StudyGameShiZiChui
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

- (void)loadShiZiChuiServerIndividualMoreGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure {
    [HttpReqMgr requestIndividualGetGameData:[AccountMgr sharedInstance].user.name
                                      gameID:StudyGameShiZiChui
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

- (void)loadShiZiChuiLocalGameData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ShiZiChui" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *key = [GlobalUtil levelKeyWith:[GameMgr sharedInstance].level];
    NSArray *questions = dict[key];
    
    self.totalQuestionCount = questions.count;
    self.curGroupCount = 0;
    self.maxGroupNum = questions.count;
    
    for (int i = 0; i < questions.count; i++) {
        NSDictionary *detail = questions[i];
        
        DDSModel *model = [[DDSModel alloc] init];
        model.modelID = [NSString stringWithFormat:@"%ld", (long)i];
        model.indexStr = detail[@"pinyin"];
        
        DDSQuestion *question = [[DDSQuestion alloc] init];
        question.title = detail[@"pinyin"];
        question.sound = detail[@"sound"];
        model.question = question;
        
        NSInteger answer = [detail[@"answer"] integerValue];
        NSArray *words = detail[@"words"];
        
        for (int j = 0; j < words.count; j++) {
            DDSOption *option = [[DDSOption alloc] init];
            option.title = words[j];
            option.isAnswer = (j + 1) == answer;
            
            [model.options addObject:option];
        }
        
        [self.models addObject:model];
    }
}

#pragma mark - 拼字锤
- (void)loadPinZiChuiServerGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure {
    [self.models removeAllObjects];
    
    [HttpReqMgr requestGetGameData:[AccountMgr sharedInstance].user.name
                            gameID:StudyGamePinZiChui
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

- (void)loadPinZiChuiServerMoreGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure {
    [HttpReqMgr requestGetGameData:[AccountMgr sharedInstance].user.name
                            gameID:StudyGamePinZiChui
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

- (void)loadPinZiChuiIndividualServerGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure {
    [self.models removeAllObjects];
    
    [HttpReqMgr requestIndividualGetGameData:[AccountMgr sharedInstance].user.name
                                      gameID:StudyGamePinZiChui
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

- (void)loadPinZiChuiIndividualServerMoreGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure {
    [HttpReqMgr requestIndividualGetGameData:[AccountMgr sharedInstance].user.name
                                      gameID:StudyGamePinZiChui
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

- (void)loadPinZiChuiLocalGameData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PinZiChui" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *key = [GlobalUtil levelKeyWith:[GameMgr sharedInstance].level];
    NSArray *questions = dict[key];
    
    self.maxGroupNum = questions.count;
    self.curGroupCount = 0;
    self.maxGroupNum = questions.count;
    
    for (int i = 0; i < questions.count; i++) {
        NSDictionary *detail = questions[i];
        
        DDSModel *model = [[DDSModel alloc] init];
        model.modelID = [NSString stringWithFormat:@"%ld", (long)i];
        model.indexStr = [NSString stringWithFormat:@"%ld", (long)i];
        
        DDSQuestion *question = [[DDSQuestion alloc] init];
        question.title = detail[@"question"];
        question.sound = detail[@"sound"];
        question.word = detail[@"word"];
        model.question = question;
        
        NSInteger answer = [detail[@"answer"] integerValue];
        NSArray *options = detail[@"options"];
        
        for (int j = 0; j < options.count; j++) {
            DDSOption *option = [[DDSOption alloc] init];
            option.title = options[j];
            option.isAnswer = (j + 1) == answer;
            [model.options addObject:option];
        }
        
        [self.models addObject:model];
    }
}

@end
