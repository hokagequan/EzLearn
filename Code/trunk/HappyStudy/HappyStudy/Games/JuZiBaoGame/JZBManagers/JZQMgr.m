//
//  JZQMgr.m
//  EasyLSP
//
//  Created by Q on 15/6/10.
//  Copyright © 2015年 LittleIsland. All rights reserved.
//

#import "JZQMgr.h"
#import "JZQModel.h"
#import "JZQWord.h"
#import "HttpReqMgr.h"
#import "AccountMgr.h"
#import "GameMgr.h"

#import "JuZiQiaoScene.h"

#import <AVFoundation/AVFoundation.h>

@interface JZQMgr()<AVSpeechSynthesizerDelegate>

@end

@implementation JZQMgr

- (void)appendDataWithInfo:(NSDictionary *)info {
    NSArray *array = info[@"Questions"];
    NSMutableArray *models = self.models;
    
    self.maxGroupNum = [info[@"TotalQuestionSize"] integerValue];
    if ([GameMgr sharedInstance].gameGroup == GroupIndividual) {
        self.maxGroupNum = [info[@"ReturnQestionNum"] integerValue];
    }
    
    NSInteger pos = [info[@"CurrentQuestionPos"] integerValue];
    self.curGroupCount = pos - array.count + 1;
    
//    // FIXME: Test
//    NSString *string = @"我爱草帽";
//    JZQModel *model = [[JZQModel alloc] init];
//    model.sentence = string;
//    for (int i = 0; i < string.length; i++) {
//        JZQWord *word = [[JZQWord alloc] init];
//        word.word = [string substringWithRange:NSMakeRange(i, 1)];
//        [model.words addObject:word];
//    }
//    [model loadIndexWithSentence:model.sentence];
//    [models addObject:model];
    
    NSInteger index = array.count - 1;
    for (int i = 0; i < array.count; i++) {
        NSDictionary *dict = array[index];
        NSDictionary *group = dict[@"Question"];
        JZQModel *model = [[JZQModel alloc] init];
        model.modelID = dict[@"QuestionsID"];
        model.indexStr = [NSString stringWithFormat:@"%@", @(pos + 1 - i)];
        model.sentence = group[@"sentence"];
        
        NSArray *words = group[@"words"];
        
        for (int j = 0; j < words.count; j++) {
            JZQWord *word = [[JZQWord alloc] init];
            word.word = words[j][@"word"];
            
            [model.words addObject:word];
        }
        
        [model loadIndexWithSentence:model.sentence];
        [GlobalUtil randomArray:model.words];
        [models addObject:model];
        
        index--;
    }
}

- (void)gameStart {
    self.stat |= JZQGameStatStart;
    [self.gameScene addCharacters:0];
}

- (void)gameLogic:(CFTimeInterval)interval {
    if (self.models.count == 0) {
        return;
    }
    
    if (!(self.stat & JZQGameStatStart)) {
        return;
    }
    
    if (self.stat & JZQGameStatPrepareCheck) {
        [self.gameScene loadFrogJumpPositions];
        self.stat &= ~JZQGameStatPrepareCheck;
        self.stat |= JZQGameStatCheck;
        if ([self isCorrect]) {
            JZQModel *model = self.models[self.gameScene.curIndex];
            AVSpeechSynthesizer *synth = [GlobalUtil speakText:model.sentence];
            synth.delegate = self;
        }
    }
    
    if (self.stat & JZQGameStatCheck) {
        if (![self.gameScene.frog isJumpCompletion]) {
            if (self.gameScene.frog.isJumping) {
                return;
            }
            
            if (self.gameScene.frog.curLocationIndex < 0) {
                [self.gameScene frogJump];
            }
            else {
                NSNumber *number = self.currentAnswers[self.gameScene.frog.curLocationIndex];
                if ([number integerValue] == self.gameScene.frog.curLocationIndex) {
                    [self.gameScene frogJump];
                }
                else {
                    JZQModel *model = self.models[self.gameScene.curIndex];
                    NSMutableArray *options = [NSMutableArray array];
                    for (JZQWord *option in model.words) {
                        [options addObject:option.word];
                    }
                    [self wrong:model.modelID questions:nil options:options];
                    [self.gameScene playWrongSound];
                    [self.gameScene frogFallDownWithLeafIndex:self.gameScene.frog.curLocationIndex];
                    self.stat &= ~JZQGameStatCheck;
                }
            }
        }
        else {
            JZQModel *model = self.models[self.gameScene.curIndex];
            NSMutableArray *options = [NSMutableArray array];
            for (JZQWord *option in model.words) {
                [options addObject:option.word];
            }
            [self correct:model.modelID questions:nil options:options];
            [self.gameScene frogHappy];
            [self.gameScene playCorrectMaleSound];
            self.stat &= ~JZQGameStatCheck;
        }
    }
}

- (BOOL)isCorrect {
    BOOL result = NO;

    for (int i = 0; i < self.currentAnswers.count; i++) {
        result = (i == [self.currentAnswers[i] intValue]);
    }
    
    return result;
}

- (void)loadJuZiQiaoServerGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure {
    [self.models removeAllObjects];
        
    [HttpReqMgr requestGetGameData:[AccountMgr sharedInstance].user.name
                            gameID:StudyGameJuZiQiao
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

- (void)loadJuZiQiaoServerMoreGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure {
    [HttpReqMgr requestGetGameData:[AccountMgr sharedInstance].user.name
                            gameID:StudyGameJuZiQiao
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

- (void)loadAnswerWithIndex:(NSInteger)index toLocation:(NSInteger)location add:(BOOL)add {
    if (index >= self.currentAnswers.count) {
        return;
    }
    
        JZQModel *model = self.models[self.gameScene.curIndex];
        JZQWord *word = model.words[index];
    if (add) {
        self.currentAnswers[location] = @(word.index);
    }
    else {
        if ([self.currentAnswers containsObject:@(word.index)]) {
            NSInteger theLocation = [self.currentAnswers indexOfObject:@(word.index)];
            self.currentAnswers[theLocation] = @(-1);
        }
    }
    
    if (![self.currentAnswers containsObject:@(-1)]) {
        self.stat |= JZQGameStatPrepareCheck;
    }
}

- (void)next {
    self.gameScene.userInteractionEnabled = YES;
    if (self.maxGroupNum == self.models.count &&
        self.gameScene.curIndex == self.models.count - 1) {
        [self.gameScene finishAll];
    }
    else {
        self.gameScene.curIndex++;
    }
}

- (void)resetAnswers {
    [self.currentAnswers removeAllObjects];
    
    NSInteger count = self.currentAnswers.count;
    if (self.gameScene.curIndex < self.models.count) {
        JZQModel *model = self.models[self.gameScene.curIndex];
        count = model.words.count;
    }
    
    for (int i = 0; i < count; i++) {
        [self.currentAnswers addObject:@(-1)];
    }
}

#pragma mark - AVSpeech
- (void)speechSynthesizer:(nonnull AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(nonnull AVSpeechUtterance *)utterance {
    self.gameScene.userInteractionEnabled = NO;
    [self performSelector:@selector(next) withObject:nil afterDelay:GAME_INTERVAL];
}

#pragma mark - Property
- (NSMutableArray *)currentAnswers {
    if (!_currentAnswers) {
        _currentAnswers = [NSMutableArray array];
    }
    
    return _currentAnswers;
}

@end
