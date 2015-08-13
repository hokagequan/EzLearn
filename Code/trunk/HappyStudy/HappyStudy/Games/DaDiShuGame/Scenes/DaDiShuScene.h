//
//  DaDiShuScene.h
//  EasyLSP
//
//  Created by Q on 15/4/7.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "HSScrollGameScene.h"
#import "DDSMgr.h"
#import "DDSGopher.h"

#define kLeftButton @"leftButton"
#define kRightButton @"rightButton"
#define kBackButton @"backButton"

@interface DaDiShuScene : HSScrollGameScene

@property (strong, nonatomic) DDSMgr *myGameMgr;

@property (strong, nonatomic) NSMutableArray *characters;
@property (strong, nonatomic) NSMutableArray *cards;
@property (strong, nonatomic) NSArray *holePostions;
@property (strong, nonatomic) NSArray *gopherPositions;

- (void)addControllers;
- (void)changeCharacterStat:(GopherStat)stat index:(NSInteger)index;
- (void)changeLifeWith:(NSInteger)life;

@end
