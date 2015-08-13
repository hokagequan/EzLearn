//
//  DaDiShuIndividualScene.m
//  EasyLSP
//
//  Created by Quan on 15/5/8.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "JuZiBaoIndividualScene.h"
#import "GameSelectIndividualScene.h"
#import "OptionLeaf.h"
#import "JZBMgr.h"
#import "AccountMgr.h"

@interface JuZiBaoIndividualScene()<UIAlertViewDelegate>

@end

@implementation JuZiBaoIndividualScene

- (void)didMoveToView:(nonnull SKView *)view {
    [super didMoveToView:view];
    
    self.uikitContainer.userInteractionEnabled = NO;
    
    [self showAD];
}

#pragma mark - Override
- (void)loadGameDataFrom:(NSInteger)fromPos count:(NSInteger)count Complete:(void (^)(void))complete failure:(void (^)(NSDictionary *))failure {
    if (![GlobalUtil isNetworkConnection]) {
        [self.myGameMgr loadLocalGameData];
        if (complete) {
            complete();
        }
        
        return;
    }
    
    if (fromPos <= 0) {
        [self.myGameMgr loadIndividualServerGameDataCompletion:^{
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
        [self.myGameMgr loadIndividualServerMoreGameDataCompletion:^{
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

- (void)addControllers {
    [super addControllers];
    
    for (HSButtonSprite *button in self.buttons) {
        button.position = CGPointMake(button.position.x, [UniversalUtil universalDelta:122]);
        if ([button.name isEqualToString:kLeftButton] ||
            [button.name isEqualToString:kRightButton]) {
            button.alpha = 0.0;
        }
        else if ([button.name isEqualToString:kBackButton]) {
            button.position = [UniversalUtil universaliPadPoint:CGPointMake(962, button.position.y)
                                                    iPhonePoint:CGPointMake(441, button.position.y)
                                                        offsetX:0
                                                        offsetY:0];
        }
    }
}

- (void)buildWorld {
    [super buildWorld];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && !IS_WIDESCREEN) {
        self.optionBackground.position = CGPointMake(self.optionBackground.position.x, self.optionBackground.position.y + 15);
        for (OptionLeaf *optionLeaf in self.optionLeafs) {
            optionLeaf.originalLocation = CGPointMake(optionLeaf.originalLocation.x, optionLeaf.originalLocation.y + 15);
            optionLeaf.position = optionLeaf.originalLocation;
        }
    }
}

- (void)clickBack:(id)sender {
    [self.myGameMgr.models removeAllObjects];
    GameSelectIndividualScene *scene = [[GameSelectIndividualScene alloc] initWithSize:self.size];
    [self.view presentScene:scene];
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

- (void)wrong {
    [AccountMgr sharedInstance].user.score--;
    
    if ([AccountMgr sharedInstance].user.score == 0) {
        [self gameOver];
    }
    else {
        self.curIndex++;
    }
}

#pragma mark - AlertView
- (void)alertViewCancel:(UIAlertView *)alertView {
    
}

@end
