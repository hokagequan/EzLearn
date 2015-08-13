//
//  DDPManagers.h
//  HappyStudy
//
//  Created by Quan on 14/10/22.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "SubGameMgr.h"

@interface DDPMgr : SubGameMgr

+ (instancetype)sharedInstance;

// 碰碰识字
- (void)loadPengPengShiZiIndividualServerGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure;
- (void)loadPengPengShiZiIndividualServerMoreGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure;
- (void)loadPengPengShiZiLocalGameData;

// 碰碰搭词
- (void)loadPengPengDaCiServerGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure;
- (void)loadPengPengDaCiServerMoreGameDataCompletion:(void (^)(void))completion failure:(void (^)(NSDictionary *))failure;

@end
