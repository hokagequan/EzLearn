//
//  GameSelectScene.h
//  HappyStudy
//
//  Created by Q on 14/10/23.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#define kAboutBtn @"AboutBtn"
#define kBackBtn @"BackBtn"
#define kBackgroundMusicBtn @"BackgroundMusicBtn"

typedef enum {
    GSWorldLayerGround = 0,
    GSWorldLayerSkyFar,
    GSWorldLayerSkyNear,
    GSWorldLayerEnvironment,
    GSWorldLayerTop,
    GSWorldLayerCount
}GSWorldLayer;

@interface GameSelectScene : SKScene

@property (strong, nonatomic) NSMutableArray *animals;
@property (strong, nonatomic) NSMutableArray *options;
@property (strong, nonatomic) NSMutableArray *buttons;

+ (void)loadAssets;

- (void)addNode:(SKNode *)node atWorldLayer:(GSWorldLayer)layer;
- (void)addGameOptions;
- (void)addHUD;
- (void)optionIsSeletedWithName:(StudyGame)studyGame;
- (void)setButtonSelectState:(NSString *)buttonName;
- (void)clickBack:(id)sender;

@end
