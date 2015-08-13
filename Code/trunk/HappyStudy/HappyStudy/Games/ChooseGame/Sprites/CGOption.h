//
//  CGAnswer.h
//  HappyStudy
//
//  Created by Q on 14-10-14.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "CGCharacter.h"
#import "ChooseGameScene.h"
#import "GlobalUtil.h"

@interface CGOption : CGCharacter

@property (nonatomic) BOOL isAnswer;
@property (nonatomic) CGFloat idleAnimationDuration;

- (id)initWithTexture:(SKTexture *)texture string:(NSString *)string position:(CGPoint)position isAnswer:(BOOL)isAnswer;
- (id)initWithString:(NSString *)string position:(CGPoint)position isAnswer:(BOOL)isAnswer;
- (NSArray *)deathAnimationFrames;
- (ChooseGameScene *)characterScene;
- (void)animationWrong;
- (void)playBoomSound;

@end
