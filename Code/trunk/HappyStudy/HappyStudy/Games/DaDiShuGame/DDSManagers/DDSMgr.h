//
//  DDSMgr.h
//  EasyLSP
//
//  Created by Quan on 15/5/7.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SubGameMgr.h"

@class DaDiShuScene;

@interface DDSMgr : SubGameMgr

@property (strong, nonatomic) DaDiShuScene *gameScene;

@property (nonatomic) NSInteger missTimes;
@property (nonatomic) NSInteger life;

// 字母锤
- (void)loadServerGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure;
- (void)loadServerMoreGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure;
- (void)loadLocalGameData;

// 识字锤
- (void)loadShiZiChuiServerGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure;
- (void)loadShiZiChuiServerMoreGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure;
- (void)loadShiZiChuiServerIndividualGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure;
- (void)loadShiZiChuiServerIndividualMoreGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure;
- (void)loadShiZiChuiLocalGameData;

// 拼字锤
- (void)loadPinZiChuiServerGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure;
- (void)loadPinZiChuiServerMoreGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure;
- (void)loadPinZiChuiIndividualServerGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure;
- (void)loadPinZiChuiIndividualServerMoreGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure;
- (void)loadPinZiChuiLocalGameData;

- (void)checkAnswerWith:(NSInteger)index;
- (BOOL)decreaseScore;
- (void)goNext;
- (void)correct;

- (BOOL)isGameEnd;

@end
