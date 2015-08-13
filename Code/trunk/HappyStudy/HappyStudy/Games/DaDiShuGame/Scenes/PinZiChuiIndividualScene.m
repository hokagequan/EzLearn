//
//  PinZiChuiIndividualScene.m
//  EasyLSP
//
//  Created by Q on 15/6/2.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "PinZiChuiIndividualScene.h"
#import "PZCIndividualMgr.h"

@implementation PinZiChuiIndividualScene

#pragma mark - Override
- (void)loadGameMgr {
    self.myGameMgr = [[PZCIndividualMgr alloc] init];
    self.myGameMgr.gameScene = self;
}

- (void)loadGameDataFrom:(NSInteger)fromPos count:(NSInteger)count Complete:(void (^)(void))complete failure:(void (^)(NSDictionary *))failure {
    if (![GlobalUtil isNetworkConnection]) {
        [self.myGameMgr loadPinZiChuiLocalGameData];
        if (complete) {
            complete();
        }
        
        return;
    }
    
    if (fromPos <= 0) {
        [self.myGameMgr loadPinZiChuiIndividualServerGameDataCompletion:^{
            if (complete) {
                complete();
            }
        } failure:^(NSDictionary *errorInfo) {
            if (failure) {
                failure(errorInfo);
            }
        }];
    }
    else {
        [self.myGameMgr loadPinZiChuiIndividualServerMoreGameDataCompletion:^{
            if (complete) {
                complete();
            }
        } failure:^(NSDictionary *errorInfo) {
            if (failure) {
                failure(errorInfo);
            }
        }];
    }
}

@end
