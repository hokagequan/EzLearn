//
//  SubGameMgr.m
//  EasyLSP
//
//  Created by Quan on 15/5/17.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "SubGameMgr.h"
#import "HttpReqMgr.h"
#import "AccountMgr.h"
#import "GameMgr.h"

@interface SubGameMgr()

@property (nonatomic) BOOL isDoingQuestion;

@end

@implementation SubGameMgr

- (instancetype)init {
    if (self = [super init]) {
        self.curLevel = [GameMgr sharedInstance].level;
    }
    
    return self;
}

- (void)correct:(NSString *)questionID questions:(NSArray *)questions options:(NSArray *)options {
    self.correctCount++;
    self.isDoingQuestion = YES;
    [AccountMgr sharedInstance].user.score++;
    
    [self submitSingleQuestion:questionID questionString:questions correct:YES option:options];
}

- (void)resetGameAnalyze {
    self.totalTimingDate = [NSDate date];
    self.correctCount = 0;
}

- (void)resetSignleQuestionAnalyze {
    if (self.isDoingQuestion) {
        self.totalQuestionCount++;
        self.isDoingQuestion = NO;
    }
    
    self.timingDate = [NSDate date];
    self.clickCount = 0;
}

- (void)submitSingleQuestion:(NSString *)questionID questionString:(NSArray *)questionString correct:(BOOL)correct option:(NSArray *)options {
    NSInteger spendTime = [[NSDate date] timeIntervalSinceDate:self.timingDate];
    
    [HttpReqMgr requestSubmit:[AccountMgr sharedInstance].user.name
                         game:[GameMgr sharedInstance].selGame
                        theID:questionID
                    spendTime:spendTime
                     clickNum:self.clickCount
               questionString:questionString
                   clickArray:options
                    isCorrect:correct
                   individual:[GameMgr sharedInstance].gameGroup == GroupIndividual
                   completion:nil
                      failure:nil];
}

- (void)submitGameCompleteInfo {
    NSInteger spendTime = [[NSDate date] timeIntervalSinceDate:self.totalTimingDate];
    [HttpReqMgr requestSubMitTotalGame:[AccountMgr sharedInstance].user.name
                                  game:[GameMgr sharedInstance].selGame
                             spendTime:spendTime
                        totalQuestions:self.totalQuestionCount
                 TotalCorrectQuestions:self.correctCount
                            individual:[GameMgr sharedInstance].gameGroup == GroupIndividual
                            completion:nil
                               failure:nil];
}

- (void)wrong:(NSString *)questionID questions:(NSArray *)questions options:(NSArray *)options {
    self.isDoingQuestion = YES;
    
    [self submitSingleQuestion:questionID questionString:questions correct:NO option:options];
}

#pragma mark - SubClass Complete
- (void)appendDataWithInfo:(NSDictionary *)info {
    // 子类继承
}

- (void)gameStart {}

- (void)gameEnd {}

- (void)gameLogic:(CFTimeInterval)interval {}

#pragma mark - Property
- (NSMutableArray *)models {
    if (!_models) {
        _models = [NSMutableArray array];
    }
    
    return _models;
}

@end
