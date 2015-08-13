//
//  VersionSeletionScene.m
//  EasyLSP
//
//  Created by Quan on 15/4/29.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "VersionSeletionScene.h"
#import "LevelSelectionScene.h"
#import "SignInSchoolScene.h"
#import "LoadingScene.h"
#import "GlobalUtil.h"
#import "GameMgr.h"
#import "HttpReqMgr.h"
#import "AccountMgr.h"
#import "SKScene+EzLearn.h"

@interface VersionSeletionScene()

@property (strong, nonatomic) SKLabelNode *character1;
@property (strong, nonatomic) SKLabelNode *character2;
@property (strong, nonatomic) SKLabelNode *character3;
@property (strong, nonatomic) SKLabelNode *character4;

@property (strong, nonatomic) UIButton *individualBtn;
@property (strong, nonatomic) UIButton *schoolBtn;

@end

@implementation VersionSeletionScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        [self buildWorld];
    }
    
    return self;
}

- (void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    
    [GameMgr sharedInstance].lastGameSelectionX = 0;
    
    [self playBackgroundMusic];
    [self buildUIComponents];
    [self startCharactersAction];
    [self spawnStarsZPosition:1];
}

- (void)willMoveFromView:(SKView *)view {
    [self destroyUIComponents];
    
    [super willMoveFromView:view];
}

- (void)buildWorld {
    // Background
    SKSpriteNode *backgroundSp = [SKSpriteNode spriteNodeWithImageNamed:@"version_selection_background"];
    backgroundSp.size = self.size;
    backgroundSp.position = CGPointMake(self.size.width / 2, self.size.height / 2);
    backgroundSp.zPosition = 0;
    [self addChild:backgroundSp];
    
    // Characters
    _character1 = [SKLabelNode labelNodeWithFontNamed:FONT_NAME_C];
    _character1.position = [UniversalUtil universaliPadPoint:CGPointMake(190, 595)
                                                 iPhonePoint:CGPointMake(92, 247)
                                                     offsetX:0
                                                     offsetY:0];
    _character1.fontColor = [UIColor whiteColor];
    _character1.fontSize = [UniversalUtil universalFontSize:96.];
    _character1.zPosition = 10;
    [self addChild:_character1];
    
    _character2 = [_character1 copy];
    _character2.position = [UniversalUtil universaliPadPoint:CGPointMake(445, 555)
                                                 iPhonePoint:CGPointMake(212, 229)
                                                     offsetX:0
                                                     offsetY:0];
    _character2.zRotation = -M_PI * 7 / 20;
    _character2.fontSize = [UniversalUtil universalFontSize:90.];;
    [self addChild:_character2];
    
    _character3 = [_character1 copy];
    _character3.position = [UniversalUtil universaliPadPoint:CGPointMake(890, 200)
                                                 iPhonePoint:CGPointMake(410, 80)
                                                     offsetX:0
                                                     offsetY:0];
    _character3.zRotation = -M_PI / 5;
    [self addChild:_character3];
    
    _character4 = [_character1 copy];
    _character4.position = [UniversalUtil universaliPadPoint:CGPointMake(540, 140)
                                                 iPhonePoint:CGPointMake(256, 64)
                                                     offsetX:0
                                                     offsetY:0];
    _character4.zRotation = -M_PI / 5;
    _character4.fontSize = [UniversalUtil universalFontSize:106.];
    [self addChild:_character4];
    
    NSArray *individualFrames = [GlobalUtil loadFramesFromAtlas:[UniversalUtil universalAtlasName:@"Individual"]
                                                   baseFileName:@"version_individual_"
                                                       frameNum:4];
    SKSpriteNode *individualSprite = [SKSpriteNode spriteNodeWithTexture:individualFrames.firstObject];
    individualSprite.position = [UniversalUtil universalPointFromCenter:CGPointMake(self.size.width / 2, self.size.height / 2)
                                                                 deltaX:-170
                                                                 deltaY:30
                                                                offsetX:0
                                                                offsetY:0];
    [self addChild:individualSprite];
    
    SKAction *individualAction = [SKAction animateWithTextures:individualFrames timePerFrame:0.5];
    [individualSprite runAction:[SKAction repeatActionForever:individualAction]];
    
    NSArray *schoolFrames = [GlobalUtil loadFramesFromAtlas:[UniversalUtil universalAtlasName:@"School"]
                                               baseFileName:@"version_school_"
                                                   frameNum:4];
    SKSpriteNode *schoolSprite = [SKSpriteNode spriteNodeWithTexture:schoolFrames.firstObject];
    schoolSprite.position = [UniversalUtil universalPointFromCenter:CGPointMake(self.size.width / 2, self.size.height / 2)
                                                             deltaX:170
                                                             deltaY:30
                                                            offsetX:0
                                                            offsetY:0];
    [self addChild:schoolSprite];
    
    SKAction *schoolAction = [SKAction animateWithTextures:schoolFrames timePerFrame:0.5];
    [schoolSprite runAction:[SKAction repeatActionForever:schoolAction]];
}

- (void)buildUIComponents {
    NSDictionary *buttonProperty = [GlobalUtil gameInfoWithKey:@"VersionSelectionInfo"];
    CGFloat fontSize = [UniversalUtil universalFontSize:[buttonProperty[@"FontSize"] floatValue]];
    // Buttons
    if (!self.individualBtn) {
        self.individualBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGSize buttonSize = [UniversalUtil universaliPadSize:CGSizeMake(300, 80) iPhoneSize:CGSIZE_NON];
        self.individualBtn.frame = CGRectMake(0, 0, buttonSize.width, buttonSize.height);
        self.individualBtn.center = [UniversalUtil universalPointFromCenter:[GlobalUtil centerInSize:self.size]
                                                                     deltaX:-170
                                                                     deltaY:80
                                                                    offsetX:0
                                                                    offsetY:0];
        [self.individualBtn setTitle:@"Individual" forState:UIControlStateNormal];
        [self.individualBtn setTitleColor:colorRGB(214, 43, 43, 1) forState:UIControlStateNormal];
        self.individualBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_HP size:fontSize];
        [self.individualBtn setBackgroundImage:[UIImage imageNamed:@"btn_background"]
                                      forState:UIControlStateNormal];
        [self.individualBtn addTarget:self
                               action:@selector(clickIndividual:)
                     forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (![self.view.subviews containsObject:self.individualBtn]) {
        [self.view addSubview:self.individualBtn];
    }
    
    if (!self.schoolBtn) {
        self.schoolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.schoolBtn.frame = self.individualBtn.bounds;
        self.schoolBtn.center = [UniversalUtil universalPointFromCenter:[GlobalUtil centerInSize:self.size]
                                                                 deltaX:170
                                                                 deltaY:80
                                                                offsetX:0
                                                                offsetY:0];
        [self.schoolBtn setTitle:@"School" forState:UIControlStateNormal];
        [self.schoolBtn setTitleColor:colorRGB(214, 43, 43, 1) forState:UIControlStateNormal];
        self.schoolBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_HP size:fontSize];
        [self.schoolBtn setBackgroundImage:[UIImage imageNamed:@"btn_background"]
                                  forState:UIControlStateNormal];
        [self.schoolBtn addTarget:self
                           action:@selector(clickSchool:)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (![self.view.subviews containsObject:self.schoolBtn]) {
        [self.view addSubview:self.schoolBtn];
    }
}

- (void)changeCharacters {
    self.character1.text = [GlobalUtil randomCharacter];
    self.character2.text = [GlobalUtil randomCharacter];
    self.character3.text = [GlobalUtil randomCharacter];
    self.character4.text = [GlobalUtil randomCharacter];
}

- (void)destroyUIComponents {
    [self.individualBtn removeFromSuperview];
    [self.schoolBtn removeFromSuperview];
}

- (void)playBackgroundMusic {
    [[SettingMgr sharedInstance] startBackgroundMusicWithName:@"signIn_bg.mp3"];
}

- (void)startCharactersAction {
    SKAction *changeAction = [SKAction runBlock:^{
        [self changeCharacters];
    }];
    SKAction *waitAction = [SKAction waitForDuration:0.8];
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[changeAction, waitAction]]] withKey:@"ChangeCharacters"];
}

#pragma mark - Actions
- (void)clickIndividual:(id)sender {
    [[GameMgr sharedInstance] authenticateGameCenter];
    
    [LoadingScene showFrom:self];
    [HttpReqMgr requestIndividualLoginWith:nil
                                      name:nil
                                identifier:[AccountMgr sharedInstance].identifier
                                completion:^(NSDictionary *info) {
                                    [GameMgr sharedInstance].gameGroup = GroupIndividual;
                                    [[AccountMgr sharedInstance] getAwardsInfo];
                                    [[AccountMgr sharedInstance] getTasksInfo];
                                    
                                    LevelSelectionScene *scene = [LevelSelectionScene sceneWithSize:self.size];
                                    [LoadingScene dismissTo:scene];
                                } failure:^(HSError *error) {
                                    [GameMgr sharedInstance].gameGroup = GroupIndividual;
                                    [AccountMgr sharedInstance].user.name = [AccountMgr sharedInstance].identifier;
                                    [[AccountMgr sharedInstance] getAwardsInfo];
                                    [[AccountMgr sharedInstance] getTasksInfo];
                                    
                                    LevelSelectionScene *scene = [LevelSelectionScene sceneWithSize:self.size];
                                    [LoadingScene dismissTo:scene];
                                    
//                                    [LoadingScene dismissTo:self];
//                                    
//                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                                                    message:error.message
//                                                                                   delegate:nil
//                                                                          cancelButtonTitle:@"OK~"
//                                                                          otherButtonTitles:nil];
//                                    [alert show];
                                }];
}

- (void)clickSchool:(id)sender {
    [GameMgr sharedInstance].gameGroup = GroupSchool;
    SignInSchoolScene *scene = [SignInSchoolScene sceneWithSize:self.size];
    [self.view presentScene:scene];
}

@end
