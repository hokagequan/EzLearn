//
//  GameMgr.m
//  HappyStudy
//
//  Created by Q on 14-10-14.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "GameMgr.h"
#import "ChooseIndividualScene.h"
#import "ChooseGameScene.h"
#import "DuiDuiPengIndividualScene.h"
#import "DuiDuiPengGameScene.h"
#import "ZiMuBaoIndividualGameScene.h"
#import "ZiMuBaoGameScene.h"
#import "DaDiShuIndividualScene.h"
#import "DaDiShuScene.h"
#import "ZiMuKuangIndividualScene.h"
#import "ZiMuKuangScene.h"
#import "BiHuaBaoIndividualScene.h"
#import "BiHuaBaoScene.h"
#import "JuZiBaoIndividualScene.h"
#import "JuZiBaoScene.h"
#import "ShiZiChuiIndividualScene.h"
#import "ShiZiChuiScene.h"
#import "PinZiBaoIndividualGameScene.h"
#import "PinZiBaoGameScene.h"
#import "PinZiChuiIndividualScene.h"
#import "PinZiChuiScene.h"
#import "PinZiKuangIndividualScene.h"
#import "PinZiKuangScene.h"
#import "ZuCiBaoIndividualScene.h"
#import "ZuCiBaoScene.h"
#import "PengPengDaCiScene.h"
#import "JuZiQiaoScene.h"
#import "LoadingScene.h"
#import "HttpReqMgr.h"
#import "AccountMgr.h"
#import "HSError.h"

#import <GameKit/GameKit.h>

@interface GameMgr()

@property (strong, nonatomic) GKLocalPlayer *player;

@end

@implementation GameMgr

+ (instancetype)sharedInstance {
    static GameMgr *_sharedGameMgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedGameMgr = [[self alloc] init];
    });
    
    return _sharedGameMgr;
}

- (id)init {
    if (self = [super init]) {
        
    }
    
    return self;
}

- (void)authenticateGameCenter {
    self.player = [GKLocalPlayer localPlayer];
    
    __block GameMgr *weakMgr = self;
    self.player.authenticateHandler = ^(UIViewController *vc, NSError *error) {
        if (weakMgr.player.isAuthenticated) {
            [HttpReqMgr requestIndividualLoginWith:weakMgr.player.playerID
                                              name:weakMgr.player.displayName
                                        identifier:[AccountMgr sharedInstance].identifier
                                        completion:^(NSDictionary *info) {
                                            
                                        } failure:^(HSError *error) {
                                            
                                        }];
        }
    };
}

- (void)loadGameFrom:(SKScene *)scene {
    if (self.selGame == StudyGameNon || self.selGame >= StudyGameMax) {
        return;
    }
    
    [LoadingScene showFrom:scene];
    
    switch (self.selGame) {
        case StudyGameTingYinShiZi: {
            if ([GameMgr sharedInstance].gameGroup == GroupIndividual) {
                ChooseIndividualScene *cgScene = [[ChooseIndividualScene alloc] initWithSize:scene.size];
                cgScene.scaleMode = SKSceneScaleModeAspectFill;
                [self doLoadGameFrom:scene to:cgScene];
            }
            else {
                ChooseGameScene *cgScene = [[ChooseGameScene alloc] initWithSize:scene.size];
                cgScene.scaleMode = SKSceneScaleModeAspectFill;
                [self doLoadGameFrom:scene to:cgScene];
            }
        }
            break;
        case StudyGamePengPengShiZi: {
            if ([GameMgr sharedInstance].gameGroup == GroupIndividual) {
                DuiDuiPengIndividualScene *ddpScene = [[DuiDuiPengIndividualScene alloc] initWithSize:scene.size];
                ddpScene.scaleMode = SKSceneScaleModeAspectFill;
                [self doLoadGameFrom:scene to:ddpScene];
            }
            else {
                DuiDuiPengGameScene *ddpScene = [[DuiDuiPengGameScene alloc] initWithSize:scene.size];
                ddpScene.scaleMode = SKSceneScaleModeAspectFill;
                [self doLoadGameFrom:scene to:ddpScene];
            }
        }
            break;
        case StudyGameZiMuBao: {
            if ([GameMgr sharedInstance].gameGroup == GroupIndividual) {
                ZiMuBaoIndividualGameScene *toScene = [[ZiMuBaoIndividualGameScene alloc] initWithSize:scene.size];
                toScene.scaleMode = SKSceneScaleModeAspectFill;
                [self doLoadGameFrom:scene to:toScene];
            }
            else {
                ZiMuBaoGameScene *toScene = [[ZiMuBaoGameScene alloc] initWithSize:scene.size];
                toScene.scaleMode = SKSceneScaleModeAspectFill;
                [self doLoadGameFrom:scene to:toScene];
            }
        }
            break;
        case StudyGameZiMuChui: {
            if ([GameMgr sharedInstance].gameGroup == GroupIndividual) {
                DaDiShuIndividualScene *toScene = [[DaDiShuIndividualScene alloc] initWithSize:scene.size];
                toScene.scaleMode = SKSceneScaleModeAspectFill;
                [self doLoadGameFrom:scene to:toScene];
            }
            else {
                DaDiShuScene *toScene = [[DaDiShuScene alloc] initWithSize:scene.size];
                toScene.scaleMode = SKSceneScaleModeAspectFill;
                [self doLoadGameFrom:scene to:toScene];
            }
        }
            break;
        case StudyGameZiMuKuang: {
            if ([GameMgr sharedInstance].gameGroup == GroupIndividual) {
                ZiMuKuangIndividualScene *toScene = [[ZiMuKuangIndividualScene alloc] initWithSize:scene.size];
                toScene.scaleMode = SKSceneScaleModeAspectFill;
                [self doLoadGameFrom:scene to:toScene];
            }
            else {
                ZiMuKuangScene *toScene = [[ZiMuKuangScene alloc] initWithSize:scene.size];
                toScene.scaleMode = SKSceneScaleModeAspectFill;
                [self doLoadGameFrom:scene to:toScene];
            }
        }
            break;
        case StudyGameBiHuaBao: {
            if ([GameMgr sharedInstance].gameGroup == GroupIndividual) {
                BiHuaBaoIndividualScene *toScene = [[BiHuaBaoIndividualScene alloc] initWithSize:scene.size];
                toScene.scaleMode = SKSceneScaleModeAspectFill;
                [self doLoadGameFrom:scene to:toScene];
            }
            else {
                BiHuaBaoScene *toScene = [[BiHuaBaoScene alloc] initWithSize:scene.size];
                toScene.scaleMode = SKSceneScaleModeAspectFill;
                [self doLoadGameFrom:scene to:toScene];
            }
        }
            break;
        case StudyGameJuZiBao: {
            if ([GameMgr sharedInstance].gameGroup == GroupIndividual) {
                JuZiBaoIndividualScene *toScene = [[JuZiBaoIndividualScene alloc] initWithSize:scene.size];
                toScene.scaleMode = SKSceneScaleModeAspectFill;
                [self doLoadGameFrom:scene to:toScene];
            }
            else {
                JuZiBaoScene *toScene = [[JuZiBaoScene alloc] initWithSize:scene.size];
                toScene.scaleMode = SKSceneScaleModeAspectFill;
                [self doLoadGameFrom:scene to:toScene];
            }
        }
            break;
        case StudyGameShiZiChui: {
            if ([GameMgr sharedInstance].gameGroup == GroupIndividual) {
                ShiZiChuiIndividualScene *toScene = [[ShiZiChuiIndividualScene alloc] initWithSize:scene.size];
                toScene.scaleMode = SKSceneScaleModeAspectFill;
                [self doLoadGameFrom:scene to:toScene];
            }
            else {
                ShiZiChuiScene *toScene = [[ShiZiChuiScene alloc] initWithSize:scene.size];
                toScene.scaleMode = SKSceneScaleModeAspectFill;
                [self doLoadGameFrom:scene to:toScene];
            }
        }
            break;
        case StudyGamePinZiBao: {
            if ([GameMgr sharedInstance].gameGroup == GroupIndividual) {
                PinZiBaoIndividualGameScene *toScene = [[PinZiBaoIndividualGameScene alloc] initWithSize:scene.size];
                toScene.scaleMode = SKSceneScaleModeAspectFill;
                [self doLoadGameFrom:scene to:toScene];
            }
            else {
                PinZiBaoGameScene *toScene = [[PinZiBaoGameScene alloc] initWithSize:scene.size];
                toScene.scaleMode = SKSceneScaleModeAspectFill;
                [self doLoadGameFrom:scene to:toScene];
            }
        }
            break;
        case StudyGamePinZiChui: {
            if ([GameMgr sharedInstance].gameGroup == GroupIndividual) {
                PinZiChuiIndividualScene *toScene = [[PinZiChuiIndividualScene alloc] initWithSize:scene.size];
                toScene.scaleMode = SKSceneScaleModeAspectFill;
                [self doLoadGameFrom:scene to:toScene];
            }
            else {
                PinZiChuiScene *toScene = [[PinZiChuiScene alloc] initWithSize:scene.size];
                toScene.scaleMode = SKSceneScaleModeAspectFill;
                [self doLoadGameFrom:scene to:toScene];
            }
        }
            break;
        case StudyGamePinZiKuang: {
            if ([GameMgr sharedInstance].gameGroup == GroupIndividual) {
                PinZiKuangIndividualScene *toScene = [[PinZiKuangIndividualScene alloc] initWithSize:scene.size];
                toScene.scaleMode = SKSceneScaleModeAspectFill;
                [self doLoadGameFrom:scene to:toScene];
            }
            else {
                PinZiKuangScene *toScene = [[PinZiKuangScene alloc] initWithSize:scene.size];
                toScene.scaleMode = SKSceneScaleModeAspectFill;
                [self doLoadGameFrom:scene to:toScene];
            }
        }
            break;
        case StudyGameZuCiBao: {
            if ([GameMgr sharedInstance].gameGroup == GroupIndividual) {
                ZuCiBaoIndividualScene *toScene = [[ZuCiBaoIndividualScene alloc] initWithSize:scene.size];
                toScene.scaleMode = SKSceneScaleModeAspectFill;
                [self doLoadGameFrom:scene to:toScene];
            }
            else {
                ZuCiBaoScene *toScene = [[ZuCiBaoScene alloc] initWithSize:scene.size];
                toScene.scaleMode = SKSceneScaleModeAspectFill;
                [self doLoadGameFrom:scene to:toScene];
            }
        }
            break;
        case StudyGamePengPengDaCi: {
            PengPengDaCiScene *toScene = [[PengPengDaCiScene alloc] initWithSize:scene.size];
            toScene.scaleMode = SKSceneScaleModeAspectFill;
            [self doLoadGameFrom:scene to:toScene];
        }
            break;
        case StudyGameJuZiQiao: {
            JuZiQiaoScene *toScene = [[JuZiQiaoScene alloc] initWithSize:scene.size];
            toScene.scaleMode = SKSceneScaleModeAspectFill;
            [self doLoadGameFrom:scene to:toScene];
        }
            break;
            
        default:
            break;
    }
}

- (void)doLoadGameFrom:(SKScene *)fScene to:(HSGameScene *)tScene {
    [tScene loadGameComplete:^{
        [LoadingScene dismissTo:tScene];
    } failure:^(NSDictionary *info) {
        [LoadingScene dismissTo:fScene];
        
        HSError *error = (HSError *)info[@"error"];
        NSString *message = error.message;
        if (!message) {
            message = @"Connection Error";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK~"
                                              otherButtonTitles:nil];
        [alert show];
    }];
}

@end
