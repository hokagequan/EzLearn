//
//  PinZiKuangIndividualScene.m
//  EasyLSP
//
//  Created by Q on 15/6/2.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "PinZiKuangIndividualScene.h"
#import "PZKIndividualMgr.h"
#import "ZMKModel.h"

@implementation PinZiKuangIndividualScene

- (void)didMoveToView:(nonnull SKView *)view {
    [super didMoveToView:view];
    
    self.uikitContainer.userInteractionEnabled = NO;
}

#pragma mark - Override
- (void)addControllers {
    [super addControllers];
    
    for (HSButtonSprite *button in self.buttons) {
        button.position = CGPointMake(button.position.x, 122);
        if ([button.name isEqualToString:kLeftButton] ||
            [button.name isEqualToString:kRightButton]) {
            button.alpha = 0.0;
        }
        else if ([button.name isEqualToString:kBackButton]) {
            button.position = CGPointMake(962, 122);
        }
    }
}

- (void)buildWorld {
    [super buildWorld];
    
    [self showAD];
}

- (void)finishAll {
    [super finishAll];
    
    self.myGameMgr.stat = ZMKGameStatEnd;
    [self showMask:YES];
    [self showShare];
}

- (void)gameOver {
    [super gameOver];
    
    self.myGameMgr.stat = ZMKGameStatEnd;
    [self playGameOverSound];
    [self showMask:YES];
    [self showShare];
}

- (void)loadGameMgr {
    self.myGameMgr = [[PZKIndividualMgr alloc] init];
    self.myGameMgr.gameScene = self;
}

- (void)loadGameDataFrom:(NSInteger)fromPos count:(NSInteger)count Complete:(void (^)(void))complete failure:(void (^)(NSDictionary *))failure {
    if (![GlobalUtil isNetworkConnection]) {
        [self.myGameMgr loadPinZiKuangLocalGameData];
        if (complete) {
            complete();
        }
        
        return;
    }

    if (fromPos <= 0) {
        [self.myGameMgr loadPinZiKuangIndividualServerGameDataCompletion:^{
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
        [self.myGameMgr loadPinZiKuangIndividualServerMoreGameDataCompletion:^{
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
