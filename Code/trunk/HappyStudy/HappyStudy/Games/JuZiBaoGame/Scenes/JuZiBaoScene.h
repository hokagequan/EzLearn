//
//  DaDiShuScene.h
//  EasyLSP
//
//  Created by Q on 15/4/7.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "HSScrollGameScene.h"
#import "JZBMgr.h"

#define kLeftButton @"leftButton"
#define kRightButton @"rightButton"
#define kBackButton @"backButton"
#define kOptionLeaf @"optionLeaf"

#define MAX_WRONG_TIMES 3

@interface JuZiBaoScene : HSScrollGameScene

@property (strong, nonatomic) SKSpriteNode *optionBackground;

@property (strong, nonatomic) JZBMgr *myGameMgr;

@property (strong, nonatomic) NSMutableArray *questionLeafs;
@property (strong, nonatomic) NSMutableArray *optionLeafs;

@property (nonatomic) BOOL isSpeakingFinish;
@property (nonatomic) BOOL isFrogAnimationFinish;

- (void)addControllers;
- (void)setFrogJumpTarget:(NSInteger)index;
- (void)frogJump;
- (void)frogFallDown;
- (void)frogHappy;
- (void)clickBack:(id)sender;
- (void)checkShouldGoNext;

@end
