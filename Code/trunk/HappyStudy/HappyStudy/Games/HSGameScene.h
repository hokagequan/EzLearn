//
//  HSGameScene.h
//  HappyStudy
//
//  Created by Q on 14-10-14.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "HSButtonSprite.h"

typedef void (^HSGSAssetLoadCompletionHandler)(void);

@interface HSGameScene : SKScene

@property (strong, nonatomic) NSMutableArray *buttons;

- (void)buildWorld;
- (void)setButtonSelectState:(NSString *)buttonName;
- (void)loadGameComplete:(void (^)(void))complete failure:(void (^)(NSDictionary *info))failure;
- (void)showShare;
- (void)hideShare;
- (void)shareCompletion:(BOOL)success;
- (void)showAD;
- (void)next;

// 预加载游戏所需图片
+ (void)loadSceneAssetsWithCompletionHandler:(HSGSAssetLoadCompletionHandler)handler;

// 加载图片
+ (void)loadSceneAssets;

// 释放加载内容
+ (void)releaseSceneAssets;

// 网络请求数据
- (void)loadGameDataFrom:(NSInteger)fromPos count:(NSInteger)count Complete:(void (^)(void))complete failure:(void (^)(NSDictionary *info))failure;

@end
