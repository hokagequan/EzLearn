//
//  DuiDuiPengGameScene.h
//  HappyStudy
//
//  Created by Quan on 14/10/22.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "HSScrollGameScene.h"
@class DDPCharacter;

#define kLeftButton @"leftButton"
#define kRightButton @"rightButton"
#define kBackButton @"backButton"

@interface DuiDuiPengGameScene : HSScrollGameScene

@property (strong, nonatomic) NSMutableArray *selectCharacters;

- (void)clickCharacter:(DDPCharacter *)character;
- (void)removeCharacter:(DDPCharacter *)character;
- (void)addControllers;
- (void)checkMatch;

@end
