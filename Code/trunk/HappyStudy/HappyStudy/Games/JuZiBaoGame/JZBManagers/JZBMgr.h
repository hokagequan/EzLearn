//
//  DDSMgr.h
//  EasyLSP
//
//  Created by Quan on 15/5/7.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SubGameMgr.h"

@class JuZiBaoScene;

typedef enum {
    JZBStatNon = 0,
    JZBStatDoChecking,
    JZBStatStartChecking,
    JZBStatDoCheckResult,
}JZBStat;

@interface JZBMgr : SubGameMgr

@property (weak, nonatomic) JuZiBaoScene *gameScene;

@property (nonatomic) NSInteger questionIndex;
@property (nonatomic) BOOL isAnswer;

@property (nonatomic) JZBStat stat;

// 句子宝
- (void)loadServerGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure;
- (void)loadServerMoreGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure;
- (void)loadIndividualServerGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure;
- (void)loadIndividualServerMoreGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure;
- (void)loadLocalGameData;

- (void)correct;
- (void)wrong;
- (void)reloadStat;


@end
