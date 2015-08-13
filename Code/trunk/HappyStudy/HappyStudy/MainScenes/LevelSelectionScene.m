//
//  LevelSelectionScene.m
//  EasyLSP
//
//  Created by Quan on 15/5/4.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "LevelSelectionScene.h"
#import "GameSelectIndividualScene.h"
#import "LoadingScene.h"
#import "VersionSeletionScene.h"
#import "HSButtonSprite.h"
#import "HSOwl.h"
#import "HSLion.h"
#import "HSBird.h"
#import "HSCrab.h"
#import "HSOctopus.h"
#import "OutlineLabel.h"
#import "GameMgr.h"

typedef NS_ENUM(NSInteger, LevelButtonName) {
    LevelButtonNameEasy = 0,
    LevelButtonNameThree,
    LevelButtonNameFour,
    LevelButtonNameFive,
    LevelButtonNameSix,
    LevelButtonNameSeven,
    LevelButtonNameEight,
    LevelButtonNameMax
};

#define kBACK_BUTTON @"BACK_BUTTON"

@interface LevelSelectionScene()

@property (strong, nonatomic) NSArray *levelTexts;
@property (strong, nonatomic) NSArray *textColors;
@property (strong, nonatomic) NSArray *textPositions;
@property (strong, nonatomic) NSMutableArray *buttons;
@property (strong, nonatomic) NSMutableArray *animals;

@end

@implementation LevelSelectionScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.textColors = @[colorRGB(255, 233, 88, 1),
                            colorRGB(255, 220, 50, 1),
                            colorRGB(255, 200, 40, 1),
                            colorRGB(255, 150, 30, 1),
                            colorRGB(255, 100, 20, 1),
                            colorRGB(255, 50, 10, 1),
                            colorRGB(255, 0, 0, 1)];
        CGFloat delta = 0;
        self.textPositions = @[[NSValue valueWithCGPoint:CGPointMake(508, 146)],
                               [NSValue valueWithCGPoint:CGPointMake(493 + delta, 235)],
                               [NSValue valueWithCGPoint:CGPointMake(527 + delta, 298)],
                               [NSValue valueWithCGPoint:CGPointMake(508 + delta, 374)],
                               [NSValue valueWithCGPoint:CGPointMake(517 + delta, 465)],
                               [NSValue valueWithCGPoint:CGPointMake(556 + delta, 534)],
                               [NSValue valueWithCGPoint:CGPointMake(478 + delta, 604)]];
        self.levelTexts = @[@"K1", @"K2", @"P1", @"P2", @"P3", @"Hard", @"Expert"];
        
        [self buildWorld];
    }
    
    return self;
}

- (void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    
    [self buildUIComponents];
}

- (void)willMoveFromView:(SKView *)view {
    [self destroyUIComponents];
    
    [super willMoveFromView:view];
}

- (void)buildWorld {
    // Background
    SKSpriteNode *backgroundSp = [SKSpriteNode spriteNodeWithImageNamed:@"level_selection_background"];
    backgroundSp.size = self.size;
    backgroundSp.position = CGPointMake(self.size.width / 2, self.size.height / 2);
    backgroundSp.zPosition = 0;
    [self addChild:backgroundSp];
    
    // Animals
    HSBird *bird = [[HSBird alloc] initWithTexture:nil];
    bird.requestedAnimation = HSAnimationStateIdle;
    bird.zPosition = 10;
    bird.anchorPoint = CGPointMake(0, 1);
    bird.position = [UniversalUtil universalPointFromCenter:[GlobalUtil centerInSize:self.size]
                                                     deltaX:-465
                                                     deltaY:268
                                                    offsetX:10
                                                    offsetY:20
                                         alliPhonesSuitable:YES];
    [self addChild:bird];
    [self.animals addObject:bird];
    
    HSOwl *owl = [[HSOwl alloc] initWithTexture:nil];
    owl.requestedAnimation = HSAnimationStateIdle;
    owl.zPosition = 10;
    owl.anchorPoint = CGPointMake(0, 1);
//    owl.position = CGPointMake(232, 766);
    owl.position = [UniversalUtil universalPointFromCenter:[GlobalUtil centerInSize:self.size]
                                                    deltaX:-280
                                                    deltaY:382
                                                   offsetX:10
                                                   offsetY:20
                                        alliPhonesSuitable:YES];
    [self addChild:owl];
    [self.animals addObject:owl];
    
    HSOctopus *octopus = [[HSOctopus alloc] initWithTexture:nil];
    octopus.requestedAnimation = HSAnimationStateIdle;
    octopus.zPosition = 10;
    octopus.anchorPoint = CGPointMake(0, 1);
//    octopus.position = CGPointMake(682, 501);
    octopus.position = [UniversalUtil universalPointFromCenter:[GlobalUtil centerInSize:self.size]
                                                        deltaX:170
                                                        deltaY:117
                                                       offsetX:10
                                                       offsetY:20
                                            alliPhonesSuitable:YES];
    [self addChild:octopus];
    [self.animals addObject:octopus];
    
    HSLion *lion = [[HSLion alloc] initWithTexture:nil];
    lion.requestedAnimation = HSAnimationStateIdle;
    lion.zPosition = 10;
    lion.anchorPoint = CGPointMake(0, 1);
//    lion.position = [UniversalUtil universaliPadPoint:CGPointMake(192, 168) iPhonePoint:CGPOINT_NON];
    lion.position = [UniversalUtil universalPointFromCenter:[GlobalUtil centerInSize:self.size]
                                                     deltaX:-320
                                                     deltaY:-216
                                                    offsetX:10
                                                    offsetY:20
                                         alliPhonesSuitable:YES];
    [self addChild:lion];
    [self.animals addObject:lion];
    
    HSCrab *crab = [[HSCrab alloc] initWithTexture:nil];
    crab.requestedAnimation = HSAnimationStateIdle;
    crab.zPosition = 10;
    crab.anchorPoint = CGPointMake(0, 1);
//    crab.position = CGPointMake(748, 154);
    crab.position = [UniversalUtil universalPointFromCenter:[GlobalUtil centerInSize:self.size]
                                                     deltaX:236
                                                     deltaY:-230
                                                    offsetX:10
                                                    offsetY:20
                                         alliPhonesSuitable:YES];
    [self addChild:crab];
    [self.animals addObject:crab];
    
    HSButtonSprite *backNode = [[HSButtonSprite alloc] initWithTitle:nil
                                                            norImage:@"about_close"
                                                            selImage:@"about_close"];
    backNode.position = [UniversalUtil universalPointFromCenter:[GlobalUtil centerInSize:self.size]
                                                         deltaX:236
                                                         deltaY:300
                                                        offsetX:0
                                                        offsetY:20
                                             alliPhonesSuitable:YES];
    backNode.name = kBACK_BUTTON;
    [self addChild:backNode];
}

- (void)buildUIComponents {
    for (NSInteger i = LevelButtonNameEasy; i < LevelButtonNameMax; i++) {
        NSString *title = self.levelTexts[i - LevelButtonNameEasy];
        OutlineLabel *button = [[OutlineLabel alloc] initWithTextColor:self.textColors[i - LevelButtonNameEasy]
                                                           borderColor:colorRGB(183, 100, 51, 1)];
        button.text = title;
        button.font = [UIFont fontWithName:FONT_NAME_HP size:[UniversalUtil universalFontSize:36.]];
        CGRect frame = button.frame;
        frame.size = [UniversalUtil universaliPadSize:CGSizeMake(200, 50) iPhoneSize:CGSIZE_NON];
        button.frame = frame;
        CGPoint centerPosition = ((NSValue *)self.textPositions[i - LevelButtonNameEasy]).CGPointValue;
        button.center = [UniversalUtil universaliPadPoint:centerPosition
                                              iPhonePoint:CGPOINT_NON
                                                  offsetX:-20
                                                  offsetY:-12 + (i == LevelButtonNameEasy ? 0 : -12) + (i >= LevelButtonNameFive ? (i - LevelButtonNameFour) * (-6) : 0)];
        button.textAlignment = NSTextAlignmentCenter;
        button.tag = i;
        [self.view addSubview:button];
        
        [self.buttons addObject:button];
    }
}

- (void)destroyUIComponents {
    for (OutlineLabel *label in self.buttons) {
        [label removeFromSuperview];
    }
}

- (void)goToGameSelection {
    GameSelectIndividualScene *scene = [[GameSelectIndividualScene alloc] initWithSize:self.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [self.view presentScene:scene];
}

- (void)setButtonSelectState:(CGPoint)loc {
    for (OutlineLabel *button in self.buttons) {
        button.font = [UIFont fontWithName:FONT_NAME_HP size:CGRectContainsPoint(button.frame, loc) ? [UniversalUtil universalFontSize:50] : [UniversalUtil universalFontSize:36.]];
    }
}

#pragma mark - Actions
- (void)clickBack:(SKNode *)button {
    VersionSeletionScene *scene = [[VersionSeletionScene alloc] initWithSize:self.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [self.view presentScene:scene];
}

#pragma mark - Loop
- (void)update:(NSTimeInterval)currentTime {
    for (HSCharacter *animal in self.animals) {
        [animal updateWithTimeSinceLastUpdate:currentTime];
    }
}

#pragma mark - UITouches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint loc = [touch locationInView:self.view];
    
    [self setButtonSelectState:loc];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint loc = [touch locationInView:self.view];
    
    [self setButtonSelectState:loc];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setButtonSelectState:CGPointZero];
    
    UITouch *touch = [touches anyObject];
    CGPoint loc = [touch locationInView:self.view];
    
    CGPoint nodeLoc = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:nodeLoc];
    
    if ([node.name isEqualToString:kBACK_BUTTON]) {
        [self clickBack:node];
        
        return;
    }
    
    for (OutlineLabel *button in self.buttons) {
        if (CGRectContainsPoint(button.frame, loc)) {
            [GameMgr sharedInstance].level = button.tag;
            
            if (button.tag >= LevelButtonNameSeven && ![GlobalUtil isNetworkConnection]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"请联网后选择此难度的游戏"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                
                return;
            }
            
            [self goToGameSelection];
            
            break;
        }
    }
}

#pragma mark - Property
- (NSMutableArray *)buttons {
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    
    return _buttons;
}

- (NSMutableArray *)animals {
    if (!_animals) {
        _animals = [NSMutableArray array];
    }
    
    return _animals;
}

- (NSArray *)levelTexts {
    if (!_levelTexts) {
        _levelTexts = [NSArray array];
    }
    
    return _levelTexts;
}

@end
