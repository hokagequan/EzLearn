//
//  LoadingScene.m
//  HappyStudy
//
//  Created by Q on 14/10/24.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "LoadingScene.h"
#import "GlobalUtil.h"

typedef enum uint8_t {
    zPosWhiteBg = 0,
    zPosEvironment = 100,
    zPosCharacter = 200,
    zPosHead = 300
} zPos;

#define AutoDismissTime 3

@interface LoadingScene ()

@property (strong, nonatomic) SKSpriteNode *head;
@property (strong, nonatomic) SKLabelNode *character;

@end

@implementation LoadingScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleNotification:)
                                                     name:kNOTIFICATION_LOADING_COMPLETE
                                                   object:nil];
        
        [self buildWorld];
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    
    [self startLoading];
    
    if (self.isFake) {
        [self schedualToDismiss];
    }
}

- (void)willMoveFromView:(SKView *)view {
    [self removeAllActions];
    
    [super willMoveFromView:view];
}

- (void)buildWorld {
    SKSpriteNode *whiteBg = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor]
                                                         size:self.size];
    whiteBg.anchorPoint = CGPointZero;
    whiteBg.position = CGPointZero;
    whiteBg.zPosition = zPosWhiteBg;
    [self addChild:whiteBg];
    
    _head = [SKSpriteNode spriteNodeWithImageNamed:@"girl_head"];
    // kudosaprk
//    _head.position = [UniversalUtil universalPointFromCenter:[GlobalUtil centerInSize:self.size]
//                                                      deltaX:180
//                                                      deltaY:46
//                                                     offsetX:0
//                                                     offsetY:0];
    // EzLearn Island
    _head.position = [UniversalUtil universalPointFromCenter:[GlobalUtil centerInSize:self.size]
                                                      deltaX:210
                                                      deltaY:46
                                                     offsetX:0
                                                     offsetY:0];
    _head.zPosition = zPosHead;
    _head.anchorPoint = CGPointMake(0.448, 0.36);
    [self addChild:_head];
    
    SKSpriteNode *evironment = [SKSpriteNode spriteNodeWithImageNamed:@"loading_page_bg"];
    evironment.position = [UniversalUtil universalPointFromCenter:[GlobalUtil centerInSize:self.size]
                                                           deltaX:0
                                                           deltaY:-100
                                                          offsetX:0
                                                          offsetY:0];
    evironment.zPosition = zPosEvironment;
    [self addChild:evironment];
    
    SKLabelNode *companyName = [SKLabelNode labelNodeWithFontNamed:FONT_NAME_HP];
    // kudosaprk
//    companyName.position = [UniversalUtil universalPointFromCenter:[GlobalUtil centerInSize:self.size]
//                                                            deltaX:-124
//                                                            deltaY:-78
//                                                           offsetX:0
//                                                           offsetY:0];
    // EzLearn Island
    companyName.position = [UniversalUtil universalPointFromCenter:[GlobalUtil centerInSize:self.size]
                                                            deltaX:-78
                                                            deltaY:-78
                                                           offsetX:0
                                                           offsetY:0];
    companyName.text = [GlobalUtil gameInfoWithKey:@"CompanyName"];
    companyName.fontColor = colorRGB(214, 43, 43, 1.);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        companyName.fontSize = 58.;
    }
    else {
        companyName.fontSize = 29.;
    }
    companyName.zPosition = zPosEvironment + 1;
    [self addChild:companyName];
    
//    NSString *companyName = [GlobalUtil gameInfoWithKey:@"CompanyName"];
//    for (int i = 0; i < companyName.length; i++) {
//        SKLabelNode *companyNameCharacter = [SKLabelNode labelNodeWithFontNamed:FONT_NAME_HP];
//        companyNameCharacter.position = CGPointMake(120 + i * 30, self.size.height / 2 - 55);
//        companyNameCharacter.text = [companyName substringWithRange:NSMakeRange(i, 1)];
//        companyNameCharacter.fontColor = colorRGB(214, 43, 43, 1.);
//        companyNameCharacter.fontSize = 58;
//        companyNameCharacter.zPosition = zPosEvironment + 1;
//        [self addChild:companyNameCharacter];
//    }
    
    _character = [SKLabelNode labelNodeWithFontNamed:FONT_NAME_C];
    // kudosaprk
//    _character.position = [UniversalUtil universalPointFromCenter:[GlobalUtil centerInSize:self.size]
//                                                           deltaX:116
//                                                           deltaY:0
//                                                          offsetX:0
//                                                          offsetY:0];
    // EzLearn Island
    _character.position = [UniversalUtil universalPointFromCenter:[GlobalUtil centerInSize:self.size]
                                                           deltaX:156
                                                           deltaY:0
                                                          offsetX:0
                                                          offsetY:0];
    _character.fontColor = [UIColor whiteColor];
    _character.fontSize = [UniversalUtil universalFontSize:80.];
    _character.zPosition = zPosCharacter;
    _character.text = @"a";
    [self addChild:_character];
}

- (void)changeCharacter {
    self.character.text = [GlobalUtil randomCharacter];
}

- (void)startLoading {
    [self startHeadAction];
    [self startCharacterAction];
}

- (void)startHeadAction {
    SKAction *rotateLeft = [SKAction rotateToAngle:-M_PI / 50 duration:1];
    SKAction *rotateRight = [SKAction rotateToAngle:M_PI / 30 duration:1];
    [self.head runAction:[SKAction repeatActionForever:[SKAction sequence:@[rotateLeft, rotateRight]]]];
}

- (void)startCharacterAction {
    SKAction *changeAction = [SKAction runBlock:^{
        [self changeCharacter];
    }];
    SKAction *waitAction = [SKAction waitForDuration:0.7];
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[changeAction, waitAction]]]];
}

- (void)schedualToDismiss {
    SKAction *pushAction = [SKAction runBlock:^{
        [LoadingScene dismissTo:self.presentScene];
    }];
    SKAction *waitAction = [SKAction waitForDuration:AutoDismissTime];
    [self runAction:[SKAction sequence:@[waitAction, pushAction]]];
}

#pragma mark - Class Function
+ (void)showFakeFrom:(SKScene *)fScene to:(SKScene *)tScene {
    if (!fScene || tScene) {
        return;
    }
    
    LoadingScene *loadingScene = [[LoadingScene alloc] initWithSize:fScene.size];
    loadingScene.isFake = YES;
    loadingScene.presentScene = tScene;
    [fScene.view presentScene:loadingScene];
}

+ (void)showFrom:(SKScene *)scene {
    if (!scene) {
        return;
    }
    
    LoadingScene *loadingScene = [[LoadingScene alloc] initWithSize:scene.size];
    [scene.view presentScene:loadingScene];
}

+ (void)dismissTo:(SKScene *)scene {
    if (!scene) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNOTIFICATION_LOADING_COMPLETE
                                                        object:scene];
}

#pragma mark - Timer
- (void)handleTimer:(NSTimer *)timer {
    SKScene *scene = (SKScene *)timer.userInfo;
    [LoadingScene dismissTo:scene];
}

#pragma mark - NOTIFICATION
- (void)handleNotification:(NSNotification *)notification {
    SKScene *scene = notification.object;
    
    [self.view presentScene:scene];
}

@end
