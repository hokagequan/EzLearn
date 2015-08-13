//
//  SubGameMgr.h
//  EasyLSP
//
//  Created by Quan on 15/5/17.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MAX_LIFE           5

@interface SubGameMgr : NSObject

@property (strong, nonatomic) NSMutableArray *models;
@property (nonatomic) NSInteger maxGroupNum;
@property (nonatomic) NSInteger curGroupCount;
@property (nonatomic) NSInteger score;

// 统计
@property (strong, nonatomic) NSDate *totalTimingDate;
@property (strong, nonatomic) NSDate *timingDate;
@property (nonatomic) NSInteger totalQuestionCount;
@property (nonatomic) NSInteger correctCount;
@property (nonatomic) NSInteger clickCount;

- (void)appendDataWithInfo:(NSDictionary *)info;
- (void)resetGameAnalyze;
- (void)resetSignleQuestionAnalyze;
- (void)correct:(NSString *)questionID options:(NSArray *)options;
- (void)wrong:(NSString *)questionID options:(NSArray *)options;
- (void)submitGameCompleteInfo;
- (void)gameStart;
- (void)gameEnd;
- (void)gameLogic:(CFTimeInterval)interval;

@end
