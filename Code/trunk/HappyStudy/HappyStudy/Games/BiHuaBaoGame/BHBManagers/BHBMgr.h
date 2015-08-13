//
//  DDSMgr.h
//  EasyLSP
//
//  Created by Quan on 15/5/7.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SubGameMgr.h"

typedef enum {
    BHBGameStatStart = 0,
    BHBGameStatEnd
}BHBGameStat;

@class BiHuaBaoScene;

@interface BHBMgr : SubGameMgr

@property (weak, nonatomic) BiHuaBaoScene *gameScene;
@property (nonatomic) BHBGameStat stat;

@property (nonatomic) CGFloat totalTime;

- (void)appendDataWithInfo:(NSDictionary *)info;

// 笔画宝
- (void)loadServerGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure;
- (void)loadServerMoreGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure;
- (void)loadServerIndividualGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure;
- (void)loadServerIndividualMoreGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure;
- (void)loadLocalGameData;

// 组词宝
- (void)loadZuCiBaoServerGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure;
- (void)loadZuCiBaoServerMoreGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure;
- (void)loadZuCiBaoIndividualServerGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure;
- (void)loadZuCiBaoIndividualServerMoreGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure;
- (void)loadZuCiBaoLocalGameData;

- (void)correct;
- (void)wrong;
- (void)clean;

@end
