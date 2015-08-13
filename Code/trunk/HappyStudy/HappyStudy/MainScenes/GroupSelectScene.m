//
//  GroupSelectScene.m
//  EasyLSP
//
//  Created by Q on 15/4/7.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "GroupSelectScene.h"
#import "SignInScene.h"
#import "LoadingScene.h"
#import "AccountMgr.h"

typedef enum {
    ZPosBG = 0,
    ZPosCharacter = 100,
    ZPosAboveCharacter = 200,
}ZPos;

#define kIndividualBtn @"IndividualBtn"
#define kSchoolBtn @"SchoolBtn"

@interface GroupSelectScene()

@property (strong, nonatomic) SKSpriteNode *IndividualBtn;
@property (strong, nonatomic) SKSpriteNode *schoolBtn;
@property (strong, nonatomic) SKTextureAtlas *environmentAtlas;

@end

@implementation GroupSelectScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        [self buildWorld];
    }
    
    return self;
}

- (void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    
    [self playBackgroundMusic];
}

- (void)willMoveFromView:(SKView *)view {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super willMoveFromView:view];
}

- (void)buildWorld {
    _environmentAtlas = [SKTextureAtlas atlasNamed:@"Environment"];
    
    SKSpriteNode *bgNode = [SKSpriteNode spriteNodeWithImageNamed:@"signin_bg"];
    bgNode.size = self.size;
    bgNode.position = CGPointMake(self.size.width / 2, self.size.height / 2);
    bgNode.zPosition = ZPosBG;
    [self addChild:bgNode];
    
    _IndividualBtn = [SKSpriteNode spriteNodeWithImageNamed:@"sign_btn_nor"];
    _IndividualBtn.position = CGPointMake(640, 226);
    _IndividualBtn.name = kIndividualBtn;
    _IndividualBtn.zPosition = ZPosCharacter;
    [self addChild:_IndividualBtn];
    
    SKLabelNode *individualLab = [SKLabelNode labelNodeWithFontNamed:FONT_NAME_HP];
    individualLab.text = @"Individual";
    individualLab.fontSize = 30.;
    individualLab.fontColor = colorRGB(214, 43, 43, 1.);
    individualLab.name = kIndividualBtn;
    individualLab.position = CGPointMake(individualLab.position.x, individualLab.position.y - 10);
    individualLab.zPosition = individualLab.zPosition + 1;
    [_IndividualBtn addChild:individualLab];
    
    _schoolBtn = [SKSpriteNode spriteNodeWithImageNamed:@"sign_btn_nor"];
    _schoolBtn.position = CGPointMake(340, 226);
    _schoolBtn.name = kSchoolBtn;
    _schoolBtn.zPosition = ZPosCharacter;
    [self addChild:_schoolBtn];
    
    SKLabelNode *schoolLab = [SKLabelNode labelNodeWithFontNamed:FONT_NAME_HP];
    schoolLab.text = @"School";
    schoolLab.fontSize = 30.;
    schoolLab.fontColor = colorRGB(214, 43, 43, 1.);
    schoolLab.name = kIndividualBtn;
    schoolLab.position = CGPointMake(schoolLab.position.x, schoolLab.position.y - 10);
    schoolLab.zPosition = individualLab.zPosition + 1;
    [_IndividualBtn addChild:individualLab];
}

- (void)goToSignIn {
    SignInScene *scene = [[SignInScene alloc] initWithSize:self.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [LoadingScene dismissTo:scene];
}

- (void)playBackgroundMusic {
    [[SettingMgr sharedInstance] startBackgroundMusicWithName:@"signIn_bg.mp3"];
}

#pragma mark - Action
- (void)clickIndividual:(id)sender {
    [AccountMgr sharedInstance].user.group = GroupIndividual;
    [self goToSignIn];
}

- (void)clickSchool:(id)sender {
    [AccountMgr sharedInstance].user.group = GroupSchool;
    [self goToSignIn];
}

#pragma mark - Touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint loc = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:loc];
    
    if ([node.name isEqualToString:kIndividualBtn]) {
        self.IndividualBtn.texture = [SKTexture textureWithImageNamed:@"sign_btn_sel"];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint loc = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:loc];
    
    if ([node.name isEqualToString:kIndividualBtn]) {
        [self clickIndividual:node];
    }
    else {
        self.IndividualBtn.texture = [SKTexture textureWithImageNamed:@"sign_btn_nor"];
    }
}

@end
