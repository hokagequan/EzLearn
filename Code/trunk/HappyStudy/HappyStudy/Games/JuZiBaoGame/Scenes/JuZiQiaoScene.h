//
//  JuZiQiaoScene.h
//  EasyLSP
//
//  Created by Q on 15/6/2.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "HSScrollGameScene.h"
#import "JZBFrog.h"
#import "JZQMgr.h"

@interface JuZiQiaoScene : HSScrollGameScene

@property (strong, nonatomic) JZBFrog *frog;

@property (strong, nonatomic) JZQMgr *myGameMgr;

@property (strong, nonatomic) NSArray *leafPositions;
@property (strong, nonatomic) NSMutableArray *questionLeafs;

- (void)addControllers;
- (void)setFrogJumpTarget:(NSInteger)index;
- (void)frogJump;
- (void)frogFallDown;
- (void)frogHappy;
- (void)buildWorld;
- (void)loadFrogJumpPositions;

@end
