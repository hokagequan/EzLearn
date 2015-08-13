//
//  DaDiShuScene.h
//  EasyLSP
//
//  Created by Q on 15/4/7.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "HSScrollGameScene.h"
#import "BHBMgr.h"

#define kLeftButton @"leftButton"
#define kRightButton @"rightButton"
#define kBackButton @"backButton"
#define kRotateLeftButton @"RotateLeftButton"
#define kRotateRightButton @"RotateRightButton"
#define kCannon @"Cannon"

@interface BiHuaBaoScene : HSScrollGameScene

@property (strong, nonatomic) HSLabelSprite *questionSprite;

@property (strong, nonatomic) BHBMgr *myGameMgr;

@property (strong, nonatomic) NSMutableArray *cards;

- (void)addControllers;
- (void)changeLifeWith:(NSInteger)life;
- (void)refreshTime:(NSInteger)time;
- (void)speakWithOptionIndex:(NSInteger)index;

@end
