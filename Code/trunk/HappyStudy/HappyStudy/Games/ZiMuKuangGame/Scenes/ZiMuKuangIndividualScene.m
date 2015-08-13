//
//  DaDiShuIndividualScene.m
//  EasyLSP
//
//  Created by Quan on 15/5/8.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "ZiMuKuangIndividualScene.h"
#import "ZMKIndividualMgr.h"
#import "AccountMgr.h"

@interface ZiMuKuangIndividualScene()<UIAlertViewDelegate>

@end

@implementation ZiMuKuangIndividualScene

- (void)didMoveToView:(nonnull SKView *)view {
    [super didMoveToView:view];
    
    self.uikitContainer.userInteractionEnabled = NO;
}

#pragma mark - Override
- (void)addControllers {
    [super addControllers];
    
    for (HSButtonSprite *button in self.buttons) {
        button.position = CGPointMake(button.position.x, [UniversalUtil universalDelta:122]);
        if ([button.name isEqualToString:kLeftButton] ||
            [button.name isEqualToString:kRightButton]) {
            button.alpha = 0.0;
        }
        else if ([button.name isEqualToString:kBackButton]) {
            button.position = [UniversalUtil universaliPadPoint:CGPointMake(962, 122)
                                                    iPhonePoint:CGPointMake(441, 61)
                                                        offsetX:0
                                                        offsetY:0];
        }
    }
}

- (void)buildWorld {
    [super buildWorld];
    
    [self showAD];
}

- (void)finishAll {
    [super finishAll];
    
    [self showMask:YES];
    [self showShare];
}

- (void)gameOver {
    [super gameOver];
    
    [self playGameOverSound];
    [self showMask:YES];
    [self showShare];
}

- (void)loadGameMgr {
    self.myGameMgr = [[ZMKIndividualMgr alloc] init];
    self.myGameMgr.gameScene = self;
}

- (void)loadGameDataFrom:(NSInteger)fromPos count:(NSInteger)count Complete:(void (^)(void))complete failure:(void (^)(NSDictionary *))failure {
    [self.myGameMgr loadLocalGameData];
    if (complete) {
        complete();
    }
}

#pragma mark - AlertView
- (void)alertViewCancel:(UIAlertView *)alertView {
    
}

@end
