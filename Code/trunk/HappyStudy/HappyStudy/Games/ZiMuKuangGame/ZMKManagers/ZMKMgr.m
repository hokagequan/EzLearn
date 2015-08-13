//
//  DDSMgr.m
//  EasyLSP
//
//  Created by Quan on 15/5/7.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "ZMKMgr.h"
#import "AccountMgr.h"
#import "ZMKModel.h"
#import "ZMKOption.h"
#import "HttpReqMgr.h"
#import "GameMgr.h"

#import "ZiMuKuangScene.h"

@interface ZMKMgr()

@property (nonatomic) BOOL isTransition;

@end

@implementation ZMKMgr

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
        ZMKModel *model = [[ZMKModel alloc] init];
        model.modelID = dict[@"QuestionsID"];
        model.indexStr = [NSString stringWithFormat:@"%@", @(pos + 1 + i)];
        ZMKQuestion *qModel = [[ZMKQuestion alloc] init];
        qModel.title = group[@"part"];
        model.question = qModel;
        
        NSArray *options = group[@"choices"];
        for (int j = 0; j < options.count; j++) {
            NSDictionary *detail = options[j];
            ZMKOption *option = [[ZMKOption alloc] init];
            option.title = detail[@"part"];
            option.sound = detail[@"audio_path"];
            option.isAnswer = [detail[@"correct"] boolValue];
            
            [model.options addObject:option];
        }
        
        [models addObject:model];
        
        index--;
    }
}

- (CGFloat)caculateStayTimeWith:(NSInteger)index {
    CGFloat time = ORIGINAL_DROPPING_TIME - 0.3 * index;
    
    return time >= MIN_DROPPING_TIME ? time : MIN_DROPPING_TIME;
}

- (void)checkNode:(HSLabelSprite *)nodeA with:(HSLabelSprite *)nodeB {
    if ([((HSLabelSprite *)nodeA).label.text isEqualToString:((HSLabelSprite *)nodeB).label.text]) {
        HSLabelSprite *fruit = [nodeA isKindOfClass:[ZMKBasket class]] ? nodeB : nodeA;
        [self.gameScene addFruitToBasket:fruit];
        [self correct];
    }
    else {
        [self.gameScene removeFruitFromBasket];
        [self wrong];
    }
}

- (void)correct {
    [self.gameScene playCorrectFemaleSound];
    
    self.clickCount++;
    ZMKModel *model = self.models[self.gameScene.curIndex];
    NSMutableArray *options = [NSMutableArray array];
    for (ZMKOption *option in model.options) {
        [options addObject:option.title];
    }
    [self correct:model.modelID options:options];
    
    self.score++;
    self.life++;
    [self.gameScene refreshScore:self.score];
    [self.gameScene changeLifeWith:self.life];
    
    self.basketFruitNumber++;
}

- (NSString *)characterInFruit {
    ZMKModel *model = self.models[self.gameScene.curIndex];
    if (model.options.count > 0) {
        ZMKOption *option = model.options.firstObject;
        [model.options removeObject:option];
        
        return option.title;
    }
    
    return nil;
}

- (void)gameStart {
    self.stat = ZMKGameStatStart;
    
    self.score = 0;
    self.life = MAX_LIFE;
}

- (void)gameEnd {
    self.stat = ZMKGameStatEnd;
}

- (void)gameLogic:(NSTimeInterval)interval {
    if (self.stat != ZMKGameStatStart || self.isTransition) {
        return;
    }
    
    if (![self.gameScene isFruitDropping]) {
        if (self.basketFruitNumber >= ZMK_PASS_COUNT) {
            self.basketFruitNumber = 0;
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
                self.isTransition = YES;
                [self.gameScene resetFruit];
                self.gameScene.userInteractionEnabled = NO;
                [self performSelector:@selector(goNext) withObject:nil afterDelay:GAME_INTERVAL];
            }
        }
        else {
            if (self.gameScene.curIndex >= self.models.count) {
                return;
            }
            
            ZMKModel *model = self.models[self.gameScene.curIndex];
            
            CGFloat duration = ORIGINAL_DROPPING_TIME;
            if ([GameMgr sharedInstance].gameGroup == GroupIndividual) {
                duration = [self caculateStayTimeWith:self.correctCount];
            }
            if (model.options.count > 0) {
                [self.gameScene dropFruitFrom:[self randomPosition]
                                         text:[self characterInFruit]
                                     duration:duration];
            }
            else {
                [self.gameScene addCharacters:self.gameScene.curIndex];
            }
        }
    }
}

- (void)goNext {
    [self.gameScene cleanBasketFruits];
    [self.gameScene next];
    self.isTransition = NO;
}

- (CGFloat)randomPositionX {
    CGFloat deltaDistance = [UniversalUtil universalDelta:200.0];
    return ([GlobalUtil randomIntegerWithMax:10] / 10.) * (self.gameScene.size.width - deltaDistance) + deltaDistance;
}

- (CGPoint)randomPosition {
    return CGPointMake([self randomPositionX], self.gameScene.size.height + 100);
}

- (void)wrong {
    [self.gameScene playWrongSound];
    
    self.clickCount++;
    ZMKModel *model = self.models[self.gameScene.curIndex];
    NSMutableArray *options = [NSMutableArray array];
    for (ZMKOption *option in model.options) {
        [options addObject:option.title];
    }
    [self wrong:model.modelID options:options];
    
    self.score--;
    self.life--;
    if (self.score < 0) {
        self.score = 0;
    }
    if (self.life < 0) {
        self.life = 0;
    }
    [self.gameScene refreshScore:self.score];
    [self.gameScene changeLifeWith:self.life];
    
    self.basketFruitNumber--;
    if (self.basketFruitNumber < 0) {
        self.basketFruitNumber = 0;
    }
}

#pragma mark - 字母筐
- (void)loadServerGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure {
    [self.models removeAllObjects];
    
    [HttpReqMgr requestGetGameData:[AccountMgr sharedInstance].user.name
                            gameID:StudyGameZiMuKuang
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
                            gameID:StudyGameZiMuKuang
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
    NSMutableArray *totalCharacters = [@[[shengmu mutableCopy], [yunmu mutableCopy], [zhengti mutableCopy]] mutableCopy];
    
    NSInteger totalCount = shengmu.count + yunmu.count + zhengti.count;
    
    NSInteger identifier = 0;
    while (self.models.count < totalCount) {
        NSUInteger randomX = [GlobalUtil randomIntegerWithMax:totalCharacters.count];
        NSMutableArray *characters = totalCharacters[randomX];
        NSUInteger randomY = [GlobalUtil randomIntegerWithMax:characters.count];
        NSDictionary *characterInfo = characters[randomY];
        
        [characters removeObject:characterInfo];
        if (characters.count == 0) {
            [totalCharacters removeObjectAtIndex:randomX];
        }
        
        ZMKModel *zmkModel = [[ZMKModel alloc] init];
        zmkModel.modelID = [NSString stringWithFormat:@"%ld", (long)identifier];
        
        ZMKQuestion *zmkQuestion = [[ZMKQuestion alloc] init];
        zmkQuestion.title = characterInfo[@"title"];
        zmkQuestion.sound = characterInfo[@"sound"];
        zmkModel.question = zmkQuestion;
        
        [self.models addObject:zmkModel];
        
        identifier++;
    }
}

#pragma mark - 拼字筐
- (void)loadPinZiKuangServerGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure {
    [self.models removeAllObjects];
    
    [HttpReqMgr requestGetGameData:[AccountMgr sharedInstance].user.name
                            gameID:StudyGamePinZiKuang
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

- (void)loadPinZiKuangServerMoreGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure {
    [HttpReqMgr requestGetGameData:[AccountMgr sharedInstance].user.name
                            gameID:StudyGamePinZiKuang
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

- (void)loadPinZiKuangIndividualServerGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure {
    [self.models removeAllObjects];
    
    [HttpReqMgr requestIndividualGetGameData:[AccountMgr sharedInstance].user.name
                                      gameID:StudyGamePinZiKuang
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

- (void)loadPinZiKuangIndividualServerMoreGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure {
    [HttpReqMgr requestIndividualGetGameData:[AccountMgr sharedInstance].user.name
                                      gameID:StudyGamePinZiKuang
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

- (void)loadPinZiKuangLocalGameData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PinZiKuang" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *key = [GlobalUtil levelKeyWith:[GameMgr sharedInstance].level];
    NSArray *questions = dict[key];
    
    self.maxGroupNum = questions.count;
    self.curGroupCount = 0;
    
    for (int i = 0; i < questions.count; i++) {
        NSDictionary *detail = questions[i];
        
        ZMKModel *model = [[ZMKModel alloc] init];
        model.modelID = [NSString stringWithFormat:@"%ld", (long)i];
        model.indexStr = model.modelID;
        
        ZMKQuestion *question = [[ZMKQuestion alloc] init];
        question.title = detail[@"question"];
        model.question = question;
        
        NSArray *options = detail[@"options"];
        
        for (int j = 0; j < options.count; j++) {
            NSDictionary *optionInfo = options[j];
            ZMKOption *option = [[ZMKOption alloc] init];
            option.title = optionInfo[@"option"];
            option.word = optionInfo[@"word"];
            option.sound = optionInfo[@"sound"];
            option.isAnswer = [optionInfo[@"isAnswer"] boolValue];
            
            [model.options addObject:option];
        }
        
        [self.models addObject:model];
    }
}

@end
