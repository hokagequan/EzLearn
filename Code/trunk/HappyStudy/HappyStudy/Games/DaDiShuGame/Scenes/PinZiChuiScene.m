//
//  PinZiChuiScene.m
//  EasyLSP
//
//  Created by Q on 15/6/2.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "PinZiChuiScene.h"
#import "PZCMgr.h"

@implementation PinZiChuiScene

#pragma mark - Override
- (void)loadGameDataFrom:(NSInteger)fromPos count:(NSInteger)count Complete:(void (^)(void))complete failure:(void (^)(NSDictionary *))failure {
    [self.myGameMgr loadPinZiChuiServerGameDataCompletion:complete
                                                failure:failure];
}

- (void)loadGameMgr {
    self.myGameMgr = [[PZCMgr alloc] init];
    self.myGameMgr.gameScene = self;
}

- (void)loadMore {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [self.myGameMgr loadPinZiChuiServerMoreGameDataCompletion:^{
        [SVProgressHUD dismiss];
        [self expandIndexController];
    } failure:^(NSDictionary *errorInfo) {
        [SVProgressHUD dismiss];
    }];
}

@end
