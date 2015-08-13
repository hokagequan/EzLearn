//
//  LoadingScene.h
//  HappyStudy
//
//  Created by Q on 14/10/24.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface LoadingScene : SKScene

@property (strong, nonatomic) SKScene *presentScene;
@property (nonatomic) BOOL isFake; // YES：Loading固定时间 NO：等待通知

+ (void)showFakeFrom:(SKScene *)fScene to:(SKScene *)tScene;
+ (void)showFrom:(SKScene *)scene;
+ (void)dismissTo:(SKScene *)scene;

@end
