//
//  PengPengDaCiScene.m
//  EasyLSP
//
//  Created by Q on 15/6/2.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "PengPengDaCiScene.h"
#import "DDPMgr.h"

@implementation PengPengDaCiScene

#pragma mark - Override
- (void)loadGameDataFrom:(NSInteger)fromPos count:(NSInteger)count Complete:(void (^)(void))complete failure:(void (^)(NSDictionary *))failure {
    DDPMgr *mgr = [DDPMgr sharedInstance];
    
    if (fromPos == 0) {
        [mgr loadPengPengDaCiServerGameDataCompletion:^{
            if (complete) {
                complete();
            }
        } failure:^(NSDictionary *info) {
            if (failure) {
                failure(info);
            }
        }];
    }
    else {
        [mgr loadPengPengDaCiServerMoreGameDataCompletion:^{
            if (complete) {
                complete();
            }
        } failure:^(NSDictionary *info) {
            if (failure) {
                failure(info);
            }
        }];
    }
}

@end
