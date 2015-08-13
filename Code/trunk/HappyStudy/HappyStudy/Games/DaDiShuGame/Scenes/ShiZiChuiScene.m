//
//  ShiZiChuiScene.m
//  EasyLSP
//
//  Created by Q on 15/6/2.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "ShiZiChuiScene.h"
#import "SKNode+PlaySound.h"
#import "DDSModel.h"

@implementation ShiZiChuiScene

#pragma mark - Override
- (void)addCharacters:(NSInteger)index {
    [super addCharacters:index];
    
//    DDSModel *model = self.myGameMgr.models[index];
//    [self playSound:model.question.sound];
}

- (void)loadGameDataFrom:(NSInteger)fromPos count:(NSInteger)count Complete:(void (^)(void))complete failure:(void (^)(NSDictionary *))failure {
    [self.myGameMgr loadShiZiChuiServerGameDataCompletion:complete
                                                failure:failure];
}

- (void)loadMore {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [self.myGameMgr loadShiZiChuiServerMoreGameDataCompletion:^{
        [SVProgressHUD dismiss];
        [self expandIndexController];
    } failure:^(NSDictionary *errorInfo) {
        [SVProgressHUD dismiss];
    }];
}

@end
