//
//  PinZiKuangScene.m
//  EasyLSP
//
//  Created by Q on 15/6/2.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "PinZiKuangScene.h"
#import "PZKMgr.h"
#import "ZMKModel.h"

@implementation PinZiKuangScene

#pragma mark - Override
- (void)addCharacters:(NSInteger)index {
    if ([self.fruit actionForKey:DROPPING_ANIMATION]) {
        [self.fruit removeActionForKey:DROPPING_ANIMATION];
    }
    
    if (index >= self.myGameMgr.models.count) {
        return;
    }
    
    ZMKModel *model = self.myGameMgr.models[index];
    self.basket.label.text = model.question.title;
    [GlobalUtil randomArray:model.options];
    
#ifdef EZLEARN_DEBUG
#else
    [self playSound:model.question.sound completion:^{
        
    }];
#endif
    
    [self dropFruitFrom:[self.myGameMgr randomPosition]
                   text:[self.myGameMgr characterInFruit]
               duration:self.droppingDuration];
}

- (void)loadGameDataFrom:(NSInteger)fromPos count:(NSInteger)count Complete:(void (^)(void))complete failure:(void (^)(NSDictionary *))failure {
    [self.myGameMgr loadPinZiKuangServerGameDataCompletion:complete
                                                 failure:failure];
}

- (void)loadMore {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [self.myGameMgr loadPinZiKuangServerMoreGameDataCompletion:^{
        [SVProgressHUD dismiss];
        [self expandIndexController];
    } failure:^(NSDictionary *errorInfo) {
        [SVProgressHUD dismiss];
    }];
}

- (void)loadGameMgr {
    self.myGameMgr = [[PZKMgr alloc] init];
    self.myGameMgr.gameScene = self;
}

@end
