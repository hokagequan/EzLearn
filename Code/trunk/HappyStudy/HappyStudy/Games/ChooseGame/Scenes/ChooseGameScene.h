//
//  ChooseGameScene.h
//  HappyStudy
//
//  Created by Q on 14-10-14.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "HSScrollGameScene.h"
#import "CGMgr.h"
@class CGOption;
@class CGQuestion;

#define kLeftButton @"leftButton"
#define kRightButton @"rightButton"
#define kSoundButton @"soundButton"
#define kBackButton @"backButton"

@interface ChooseGameScene : HSScrollGameScene

//@property (strong, nonatomic) NSMutableArray *questionCharacters;
@property (strong, nonatomic) CGQuestion *question;
@property (strong, nonatomic) NSMutableArray *optionCharacters;
//@property (strong, nonatomic) NSMutableArray *toDestroyQuestions;
//@property (strong, nonatomic) NSMutableArray *toDestroyOptions;
@property (strong, nonatomic) NSArray *optionPositions;

@property (strong, nonatomic) CGMgr *myGameMgr;

@property (strong, nonatomic) SKSpriteNode *nearCloud;
@property (strong, nonatomic) SKSpriteNode *farCloud;
@property (strong, nonatomic) SKTexture *bubbleTexture;

- (void)clickOption:(CGOption *)optionSp;
- (void)reloadAllInterface;
- (void)finishAll;
- (void)playSound:(CGQuestion *)questionSp;
- (void)buildWorld;
- (void)addControllers;
- (void)chooseCorrect:(CGOption *)optionSp;

- (Class)ballonClass:(NSInteger)index;

@end
