//
//  DuiDuiPengIndividualScene.m
//  EasyLSP
//
//  Created by Q on 15/6/11.
//  Copyright © 2015年 LittleIsland. All rights reserved.
//

#import "DuiDuiPengIndividualScene.h"
#import "DDPMgr.h"
#import "HSError.h"

@implementation DuiDuiPengIndividualScene

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
                                                    iPhonePoint:CGPointMake(30, 61)
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
    [self playGameOverSound];
    [self showMask:YES];
    [self showShare];
}

- (void)loadGameDataFrom:(NSInteger)fromPos count:(NSInteger)count Complete:(void (^)(void))complete failure:(void (^)(NSDictionary *))failure {
    if (![GlobalUtil isNetworkConnection]) {
        [[DDPMgr sharedInstance] loadPengPengShiZiLocalGameData];
        
        if (complete) {
            complete();
        }
        
        return;
    }

    if (fromPos <= 0) {
        [[DDPMgr sharedInstance] loadPengPengShiZiIndividualServerGameDataCompletion:^{
            if ([DDPMgr sharedInstance].models.count == 0) {
                if (failure) {
                    HSError *error = [HSError errorWith:HSHttpErrorCodeNoData];
                    failure(@{@"error": error});
                }
            }
            else {
                if (complete) {
                    complete();
                }
            }
        } failure:^(NSDictionary *errorInfo) {
            if (failure) {
                failure(errorInfo);
            }
        }];
    }
    else {
        [[DDPMgr sharedInstance] loadPengPengShiZiIndividualServerMoreGameDataCompletion:^{
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
