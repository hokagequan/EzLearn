//
//  PinZiBaoIndividualGameScene.m
//  EasyLSP
//
//  Created by Q on 15/6/2.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "PinZiBaoIndividualGameScene.h"
#import "CGMgr.h"

@implementation PinZiBaoIndividualGameScene

- (void)didMoveToView:(nonnull SKView *)view {
    [super didMoveToView:view];
    
    self.uikitContainer.userInteractionEnabled = NO;
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

- (void)loadGameDataFrom:(NSInteger)fromPos count:(NSInteger)count Complete:(void (^)(void))complete failure:(void (^)(NSDictionary *))failure {
    CGMgr *mgr = [CGMgr sharedInstance];
    
    if (![GlobalUtil isNetworkConnection]) {
        [mgr loadPinZiBaoLocalGameData];
        
        if (complete) {
            complete();
        }
        
        return;
    }
    
    if (fromPos <= 0) {
        [mgr loadPinZiBaoIndividualServerGameDataCompletion:^{
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
        [mgr loadPinZiBaoIndividualServerMoreGameDataCompletion:^{
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
