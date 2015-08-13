//
//  CGMgr.h
//  HappyStudy
//
//  Created by Q on 14-10-15.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "SubGameMgr.h"
#import "CGChooseModel.h"

@interface CGMgr : SubGameMgr

+ (instancetype)sharedInstance;
+ (void)loadLocalGameDataZiMuBaoShengMu;
+ (void)loadLocalGameDataZiMuBaoYunMu;
+ (void)loadLocalGameDataZiMuBaoZhengTi;

- (void)appendDataWithInfo:(NSDictionary *)info;

// 听音识字
- (void)loadTingYinShiZiLocalGameData;
- (void)loadTingYinShiZiIndividualGameDataFrom:(NSInteger)fromPos count:(NSInteger)count Complete:(void (^)(void))complete failure:(void (^)(NSDictionary *info))failure;

// 拼字宝
- (void)loadPinZiBaoServerGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure;
- (void)loadPinZiBaoServerMoreGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure;
- (void)loadPinZiBaoIndividualServerGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure;
- (void)loadPinZiBaoIndividualServerMoreGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure;
- (void)loadPinZiBaoLocalGameData;

@end
