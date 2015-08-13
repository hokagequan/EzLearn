//
//  HSGameScene.m
//  HappyStudy
//
//  Created by Q on 14-10-14.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "HSGameScene.h"
#import "GameSelectScene.h"
#import "GameSelectIndividualScene.h"
#import "HSOwl.h"
#import "ShareNode.h"
#import "ShareUtil.h"
#import "GameMgr.h"
#import "HttpReqMgr.h"
#import "AccountMgr.h"
#import "WXApi.h"

#import <TencentOpenAPI/TencentOAuth.h>

#define kTWITTER_BUTTON @"TWITTER_BUTTON"
#define kWEIBO_BUTTON @"WEIBO_BUTTON"
#define kFACEBOOK_BUTTON @"FACEBOOK_BUTTON"
#define kWEIXIN_BUTTON @"WEIXIN_BUTTON"
#define kQQ_BUTTON @"QQ_BUTTON"
#define kCLOSE_BUTTON @"CLOSE_BUTTON"
#define kAD_BUTTON @"AD_BUTTON"

@interface HSGameScene()<ShareNodeDelegate>

@property (strong, nonatomic) ShareNode *shareNode;

@property (strong, nonatomic) NSString *shareText;
@property (strong, nonatomic) UIImage *shareImg;

@end

@implementation HSGameScene

- (void)buildWorld {}

- (void)dismissToGameSelection {
    SKScene *scene;
    if ([GameMgr sharedInstance].gameGroup == GroupIndividual) {
        scene = [[GameSelectIndividualScene alloc] initWithSize:self.size];
    }
    else {
        scene = [[GameSelectScene alloc] initWithSize:self.size];
    }
    
    [self.view presentScene:scene];
}

- (void)hideShare {
    [self.shareNode removeFromParent];
}

- (void)loadGameComplete:(void (^)(void))complete failure:(void (^)(NSDictionary *))failure {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        dispatch_async(queue, ^{
            [self loadGameDataFrom:0 count:1000 Complete:^{
                dispatch_semaphore_signal(semaphore);
            } failure:^(NSDictionary *info) {
                dispatch_semaphore_signal(semaphore);
                if (failure) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failure(info);
                    });
                }
            }];
        });
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_async(queue, ^{
            [[self class] loadSceneAssetsWithCompletionHandler:^{
                if (complete) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        complete();
                    });
                }
            }];
        });
    });
}

- (void)setButtonSelectState:(NSString *)buttonName {
    NSString *name = buttonName;
    if (!name) {
        name = @"non";
    }
    for (HSButtonSprite *button in self.buttons) {
        button.selected = [button.name isEqualToString:name];
    }
}

- (void)showShare {
    self.shareNode = [[ShareNode alloc] initWithSize:self.size];
    self.shareNode.delegate = self;
    
    GetShareContent block = ^(ShareType type) {
        [HttpReqMgr requestGetShareContent:[AccountMgr sharedInstance].user.name
                                    gameID:[GameMgr sharedInstance].selGame
                                completion:^(NSDictionary *info) {
                                    NSString *content = info[@"ShareText"];
                                    [self.shareNode doShareWithType:type
                                                               text:content
                                                              image:nil
                                                                url:nil];
                                } failure:^(HSError *error) {
                                    [self shareNode:self.shareNode didFinishShare:NO];
                                }];
    };
    
    self.shareNode.getShareContentBlock = block;
    [self.shareNode showInNode:self];
}

- (void)shareCompletion:(BOOL)success {
    if (success) {
        [self dismissToGameSelection];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"分享失败"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)showAD {
    SKSpriteNode *adSp = [SKSpriteNode spriteNodeWithImageNamed:@"ad_bg"];
    adSp.zPosition = 9000;
    adSp.position = CGPointMake(self.size.width / 2, adSp.size.height / 2);
    adSp.name = kAD_BUTTON;
    adSp.size = CGSizeMake(self.size.width, adSp.size.height);
    [self addChild:adSp];
}

- (void)clickAD {
    // TODO:跳转广告
}

#pragma mark - Class Function
+ (void)loadSceneAssetsWithCompletionHandler:(HSGSAssetLoadCompletionHandler)handler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self loadSceneAssets];
        
        if (!handler) {
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            handler();
        });
    });
}

+ (void)loadSceneAssets {
    // 子类继承
}

+ (void)releaseSceneAssets {
    // 子类继承
}

- (void)loadGameDataFrom:(NSInteger)fromPos count:(NSInteger)count Complete:(void (^)(void))complete failure:(void (^)(NSDictionary *))failure {
    // 子类继承
}

- (void)next {
    // 子类继承
}

#pragma mark - ShareNodeDelegate
- (void)shareNode:(ShareNode *)shareNode didFinishShare:(BOOL)success {
    [self shareCompletion:success];
}

- (void)didClickClose:(ShareNode *)shareNode {
    [self dismissToGameSelection];
}

#pragma mark - Touches
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint position = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:position];
    
    if ([node.name isEqualToString:kAD_BUTTON]) {
        [self clickAD];
    }
    
    [self.shareNode handleNodeName:node.name];
}

#pragma mark - Property
- (NSMutableArray *)buttons {
    if (!_buttons) {
        _buttons = [[NSMutableArray alloc] init];
    }
    
    return _buttons;
}

@end
