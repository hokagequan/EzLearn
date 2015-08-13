//
//  ShiZiChuiIndividualScene.m
//  EasyLSP
//
//  Created by Q on 15/6/2.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "ShiZiChuiIndividualScene.h"
#import "DDSModel.h"
#import "SKNode+PlaySound.h"

@implementation ShiZiChuiIndividualScene

#pragma mark - Override
- (void)addCharacters:(NSInteger)index {
    [super addCharacters:index];
    
//    DDSModel *model = self.myGameMgr.models[index];
//    [self playSound:model.question.sound];
}

- (void)loadGameDataFrom:(NSInteger)fromPos count:(NSInteger)count Complete:(void (^)(void))complete failure:(void (^)(NSDictionary *))failure {
    if (![GlobalUtil isNetworkConnection]) {
        [self.myGameMgr loadShiZiChuiLocalGameData];
        if (complete) {
            complete();
        }
        
        return;
    }
    
    if (fromPos <= 0) {
        [self.myGameMgr loadShiZiChuiServerIndividualGameDataCompletion:^{
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
        [self.myGameMgr loadShiZiChuiServerIndividualMoreGameDataCompletion:^{
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
