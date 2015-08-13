//
//  GameMgr.h
//  HappyStudy
//
//  Created by Q on 14-10-14.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface GameMgr : NSObject

@property (nonatomic) StudyGame selGame;
@property (nonatomic) Group gameGroup;
@property (nonatomic) NSInteger level;
@property (nonatomic) CGFloat lastGameSelectionX;

+ (instancetype)sharedInstance;

- (void)loadGameFrom:(SKScene *)scene;
- (void)authenticateGameCenter;

@end
