//
//  JZBFrog.h
//  EasyLSP
//
//  Created by Quan on 15/5/14.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "HSFrog.h"

@interface JZBFrog : HSFrog

@property (strong, nonatomic) NSMutableArray *allJumpPositions;

@property (nonatomic) NSInteger curLocationIndex;
@property (nonatomic) NSInteger targetLocationIndex;
@property (nonatomic) BOOL isJumping;

- (void)jump;
- (void)animationHappyCompletion:(void (^)())completion;
- (BOOL)isJumpCompletion;

@end
