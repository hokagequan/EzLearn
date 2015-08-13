//
//  ChooseIndividualScene.m
//  EasyLSP
//
//  Created by Q on 15/6/11.
//  Copyright © 2015年 LittleIsland. All rights reserved.
//

#import "ChooseIndividualScene.h"
#import "CGMgr.h"

@implementation ChooseIndividualScene

- (void)didMoveToView:(nonnull SKView *)view {
    [super didMoveToView:view];
    
    self.uikitContainer.userInteractionEnabled = NO;
}

#pragma mark - Override
- (void)addControllers {
    [super addControllers];
    
    for (HSButtonSprite *button in self.buttons) {
        if (![button.name isEqualToString:kSoundButton]) {
            button.position = CGPointMake(button.position.x, button.position.y + [UniversalUtil universalDelta:10]);
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
    if (![GlobalUtil isNetworkConnection]) {
        [[CGMgr sharedInstance] loadTingYinShiZiLocalGameData];
        
        if (complete) {
            complete();
        }
        
        return;
    }
    
    [[CGMgr sharedInstance] loadTingYinShiZiIndividualGameDataFrom:fromPos
                                                             count:count
                                                          Complete:complete
                                                           failure:failure];
}

@end
