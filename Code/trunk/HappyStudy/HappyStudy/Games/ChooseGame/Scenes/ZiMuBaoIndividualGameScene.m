//
//  ZiMuBaoIndividualGameScene.m
//  EasyLSP
//
//  Created by Quan on 15/6/1.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "ZiMuBaoIndividualGameScene.h"

@implementation ZiMuBaoIndividualGameScene

- (void)didMoveToView:(nonnull SKView *)view {
    [super didMoveToView:view];
}

#pragma mark - Override
- (void)addControllers {
    [super addControllers];
    
    for (HSButtonSprite *button in self.buttons) {
        if (![button.name isEqualToString:kSoundButton]) {
            button.position = CGPointMake(button.position.x, [UniversalUtil universalDelta:122]);
        }
    }
}

- (void)buildWorld {
    [super buildWorld];
    
    [self showAD];
}

- (void)finishAll {
    NSInteger count = self.gameMgr.models.count;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [self loadGameDataFrom:self.gameMgr.models.count count:1000 Complete:^{
        [SVProgressHUD dismiss];
        if (count < self.gameMgr.models.count) {
            [self expandIndexController];
            self.curIndex++;
        }
        else {
            [super finishAll];
            
            [self showMask:YES];
            [self showShare];
        }
    } failure:^(NSDictionary *info) {
        [SVProgressHUD dismiss];
        
        [super finishAll];
        
        [self showMask:YES];
        [self showShare];
    }];
}

- (void)gameOver {
    [super gameOver];
    
    [self playGameOverSound];
    [self showMask:YES];
    [self showShare];
}

@end
