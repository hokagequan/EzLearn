//
//  GameSelectScene.m
//  HappyStudy
//
//  Created by Q on 14/10/23.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "GameSelectScene.h"
#import "VersionSeletionScene.h"
#import "SignInSchoolScene.h"
#import "AboutScene.h"
#import "HSLabelSprite.h"
#import "HSButtonSprite.h"
#import "HSAnimal.h"
#import "HSCrab.h"
#import "GameMgr.h"
#import "AccountMgr.h"
#import "AppDelegate.h"

#define GAME_SELECTION_WIDTH 2948

@interface GameSelectScene ()

@property (strong, nonatomic) NSMutableArray *layers;
@property (strong, nonatomic) SKSpriteNode *nearCloud;
@property (strong, nonatomic) SKSpriteNode *farCloud;
@property (nonatomic) CGSize bgSize;
@property (nonatomic) CGPoint lastLoc;
@property (nonatomic) CGFloat rateX;
@property (nonatomic) CGFloat rateY;
@property (nonatomic) BOOL worldMoved;

@end

@implementation GameSelectScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        _animals = [[NSMutableArray alloc] init];
        _buttons = [[NSMutableArray alloc] init];
        _options = [[NSMutableArray alloc] initWithCapacity:10];
        
        _layers = [NSMutableArray arrayWithCapacity:GSWorldLayerCount];
        for (int i = 0; i < GSWorldLayerCount; i++) {
            SKNode *layer = [[SKNode alloc] init];
            layer.zPosition = i - GSWorldLayerCount;
            layer.userInteractionEnabled = NO;
            [self addChild:layer];
            [_layers addObject:layer];
        }
        [GameSelectScene loadAssets];
        
        self.rateX = self.size.width / 1024;
        self.rateY = self.size.height / 768;
    }
    
    return self;
}

- (void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    
    [self buildWorld];
    [self playBackgroundMusic];
    [self startAnimations];
    [self setWorldPosition:[GameMgr sharedInstance].lastGameSelectionX];
}

- (void)addNode:(SKNode *)node atWorldLayer:(GSWorldLayer)layer {
    SKNode *layerNode = self.layers[layer];
    [layerNode addChild:node];
}

- (void)addGameOptions {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"GameSelect" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    for (int i = 0; i < array.count; i++) {
        NSDictionary *dict = array[i];
        CGPoint animalPosition = CGPointMake([dict[@"animalX"] floatValue], [dict[@"animalY"] floatValue]);
        [self addAnimalSprite:dict[@"animal"]
                     position:[UniversalUtil universaliPadPoint:animalPosition rateX:self.rateX rateY:self.rateY]
                         name:[NSString stringWithFormat:@"%@", @(i + 1)]];
        UIColor *norColor = colorRGB(96, 48, 24, 1);
        if (i + 1 >= StudyGameMax) {
            norColor = colorRGB(235, 200, 145, 1);
        }
        
        CGPoint position = CGPointMake([dict[@"x"] floatValue], [dict[@"y"] floatValue]);
        [self addGameOptionString:dict[@"title"]
                         position:[UniversalUtil universaliPadPoint:position rateX:self.rateX rateY:self.rateY]
                        textColor:norColor
                             game:(StudyGame)(i + 1)];
    }
}

- (void)addHUD {
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:[UniversalUtil universalAtlasName:@"Environment"]];
    NSInteger score = [AccountMgr sharedInstance].user.score;
    HSLabelSprite *scoreNode = [[HSLabelSprite alloc] initWithTexture:[atlas textureNamed:@"heart"]
                                                                title:[NSString stringWithFormat:@"%@", @(score)]];
    scoreNode.size = [UniversalUtil universaliPadSize:CGSizeMake(135, 115)
                                           iPhoneSize:CGSIZE_NON];
    scoreNode.position = [UniversalUtil universaliPadPoint:CGPointMake(102, 693)
                                               iPhonePoint:CGPOINT_NON
                                                   offsetX:0
                                                   offsetY:-60];
    scoreNode.label.fontName = FONT_NAME_HP;
    scoreNode.label.fontSize = [UniversalUtil universalFontSize:60.];
    scoreNode.label.position = CGPointMake(scoreNode.label.position.x, scoreNode.label.position.y - [UniversalUtil universalDelta:8]);
    [self addNode:scoreNode atWorldLayer:GSWorldLayerTop];
    
    HSButtonSprite *aboutNode = [[HSButtonSprite alloc] initWithTitle:@"About"
                                                             norImage:@"about_btn_nor"
                                                             selImage:@"about_btn_sel"];
    aboutNode.name = kAboutBtn;
    aboutNode.position = [UniversalUtil universaliPadPoint:CGPointMake(248, 693)
                                               iPhonePoint:CGPOINT_NON
                                                   offsetX:0
                                                   offsetY:-60];
    aboutNode.label.fontSize = [UniversalUtil universalFontSize:23.];
    aboutNode.label.fontName = FONT_NAME_HP;
    [self addNode:aboutNode atWorldLayer:GSWorldLayerTop];
    [self.buttons addObject:aboutNode];
    
    HSButtonSprite *backNode = [[HSButtonSprite alloc] initWithTitle:nil
                                                            norImage:@"back_nor"
                                                            selImage:@"back_sel"];
    backNode.position = [UniversalUtil universaliPadPoint:CGPointMake(381, 693)
                                              iPhonePoint:CGPOINT_NON
                                                  offsetX:0
                                                  offsetY:-60];
    backNode.name = kBackBtn;
    [self addNode:backNode atWorldLayer:GSWorldLayerTop];
    [self.buttons addObject:backNode];
    
    HSButtonSprite *bgMusicSwitch = [[HSButtonSprite alloc] initWithTitle:nil
                                                                 norImage:@"music_on"
                                                                 selImage:@"music_off"];
    bgMusicSwitch.position = CGPointMake(self.size.width - 113, 20);
    bgMusicSwitch.position = CGPointMake(self.size.width - [UniversalUtil universalDelta:113], [UniversalUtil universalDelta:20]);
    bgMusicSwitch.anchorPoint = CGPointZero;
    bgMusicSwitch.name = kBackgroundMusicBtn;
    bgMusicSwitch.selected = [SettingMgr sharedInstance].bgMusicOff;
    [self addNode:bgMusicSwitch atWorldLayer:GSWorldLayerTop];
}

- (void)addEnvironment {
//    HSCrab *crab = [[HSCrab alloc] initWithTexture:nil];
//    crab.position = CGPointMake(1000, 92);
//    [self addNode:crab atWorldLayer:GSWorldLayerEnvironment];
//    [self.animals addObject:crab];
    
    SKSpriteNode *treeLeft = [SKSpriteNode spriteNodeWithImageNamed:@"tree_left"];
    treeLeft.position = CGPointMake(treeLeft.size.width / 2, [UniversalUtil universalDelta:504]);
    [self addNode:treeLeft atWorldLayer:GSWorldLayerEnvironment];
    
    SKSpriteNode *treeMid = [SKSpriteNode spriteNodeWithImageNamed:@"tree_middle"];
//    treeMid.position = CGPointMake(920, 600);
    treeMid.position = [UniversalUtil universaliPadPoint:CGPointMake(920, 600)
                                             iPhonePoint:CGPointMake(460, 520)
                                                 offsetX:0
                                                 offsetY:0];
    [self addNode:treeMid atWorldLayer:GSWorldLayerEnvironment];
    
//    SKSpriteNode *surfboard = [SKSpriteNode spriteNodeWithImageNamed:@"surfboard"];
////    surfboard.position = CGPointMake(1800, 570);
//    surfboard.position = [UniversalUtil universaliPadPoint:CGPointMake(1800, 570)
//                                               iPhonePoint:CGPOINT_NON
//                                                   offsetX:0
//                                                   offsetY:0];
//    [self addNode:surfboard atWorldLayer:GSWorldLayerEnvironment];
}

- (void)addCloud {
    _nearCloud = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"game_sel_big_cloud_near"]
                                                size:[UniversalUtil universaliPadSize:CGSizeMake(260 * 1.3, 83 * 1.3) iPhoneSize:CGSIZE_NON]];
//    _nearCloud.position = CGPointMake(self.size.width / 2, [UniversalUtil universalDelta:680]);
    _nearCloud.position = [UniversalUtil universaliPadPoint:CGPointMake(self.size.width / 2, 680)
                                                iPhonePoint:CGPointMake(self.size.width / 2, 300)
                                                    offsetX:0
                                                    offsetY:0];
    [self addNode:_nearCloud atWorldLayer:GSWorldLayerSkyNear];
    
    _farCloud = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"game_sel_big_cloud_far"]
                                               size:[UniversalUtil universaliPadSize:CGSizeMake(375 * 1.3, 64 * 1.3) iPhoneSize:CGSIZE_NON]];
//    _farCloud.position = CGPointMake(self.size.width / 2 + [UniversalUtil universalDelta:380], [UniversalUtil universalDelta:700]);
    _farCloud.position = [UniversalUtil universaliPadPoint:CGPointMake(self.size.width / 2 + 380, 700)
                                               iPhonePoint:CGPointMake(self.size.width / 2 + 180, 310)
                                                   offsetX:0
                                                   offsetY:0];
    [self addNode:_farCloud atWorldLayer:GSWorldLayerSkyFar];
}

- (void)addGameOptionString:(NSString *)string position:(CGPoint)position textColor:(UIColor *)textColor game:(StudyGame)game {
    NSString *gameStr = [NSString stringWithFormat:@"%@", @(game)];
    
    SKLabelNode *lab = [SKLabelNode labelNodeWithFontNamed:FONT_NAME_CUTOON];
    lab.position = position;
    lab.fontSize = [UniversalUtil universalFontSize:24.];
    lab.fontColor = textColor;
    lab.text = string;
    lab.name = gameStr;
    lab.zRotation = M_PI / 60;
    lab.zPosition = 10;
    [self addNode:lab atWorldLayer:GSWorldLayerGround];
    [self.options addObject:lab];
    
    SKSpriteNode *optionSp = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(120, 90)];
    optionSp.position = position;
    optionSp.name = gameStr;
    [self addNode:optionSp atWorldLayer:GSWorldLayerGround];
}

- (void)addAnimalSprite:(NSString *)className position:(CGPoint)position name:(NSString *)name {
    HSAnimal *animal = nil;
    if (className.length == 0) {
        animal = [HSAnimal spriteNodeWithImageNamed:@"lock"];
    }
    else {
        animal = [[NSClassFromString(className) alloc] initWithTexture:nil];
    }
    animal.position = position;
    animal.name = name;
    animal.zPosition = 10;
    [self.animals addObject:animal];
    [self addNode:animal atWorldLayer:GSWorldLayerGround];
}

- (void)buildWorld {
    if ([self.layers[GSWorldLayerGround] children].count > 0) {
        return;
    }
    
    SKSpriteNode *bgNode = [SKSpriteNode spriteNodeWithImageNamed:@"game_sel_bg"];
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        bgNode.size = CGSizeMake(self.size.width * 2, self.size.height);
//    }
//    else {
//        bgNode.size = CGSizeMake(1024 * self.size.height / 384, self.size.height);
//    }
    bgNode.size = CGSizeMake(self.size.width * 2, self.size.height);
    bgNode.anchorPoint = CGPointZero;
    [self addNode:bgNode atWorldLayer:GSWorldLayerGround];
    
    SKSpriteNode *bgNode2 = [SKSpriteNode spriteNodeWithImageNamed:@"game_sel_bg"];
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        bgNode2.size = CGSizeMake(self.size.width * 2, self.size.height);
//    }
//    else {
//        bgNode2.size = CGSizeMake(1024 * self.size.height / 384, self.size.height);
//    }
    bgNode2.size = CGSizeMake(self.size.width * 2, self.size.height);
    bgNode2.anchorPoint = CGPointZero;
    bgNode2.position = CGPointMake(bgNode.size.width, 0);
    [self addNode:bgNode2 atWorldLayer:GSWorldLayerGround];
    
    self.bgSize = CGSizeMake([UniversalUtil universalDelta:GAME_SELECTION_WIDTH horizantal:YES allIPhonesSuitable:YES],
                             bgNode.size.height);
    
    [self addGameOptions];
    [self addHUD];
    [self addEnvironment];
    [self addCloud];
}

- (void)optionIsSeletedWithName:(StudyGame)studyGame {
    if (studyGame == StudyGameNon ||
        studyGame >= StudyGameMax) {
        return;
    }
    
    for (SKLabelNode *option in self.options) {
        if ([option.name integerValue] == studyGame) {
            SKAction *zoomOut = [SKAction scaleTo:1.25 duration:0.2];
            SKAction *loadGame = [SKAction runBlock:^{
                [GameMgr sharedInstance].selGame = studyGame;
                [[GameMgr sharedInstance] loadGameFrom:self];
            }];
            SKAction *zoomIn = [SKAction scaleTo:1.0 duration:0.2];
            
            [option runAction:[SKAction sequence:@[zoomOut, loadGame, zoomIn]]];
            
            return;
        }
    }
}

- (void)playBackgroundMusic {
    [[SettingMgr sharedInstance] startBackgroundMusicWithName:@"game_select_bg.wav"];
}

- (void)startAnimations {
    [self startAnimalsAnimation];
    [self startCloudAnimation];
}

- (void)startAnimalsAnimation {
    for (HSAnimal *animal in self.animals) {
        animal.requestedAnimation = HSAnimationStateIdle;
    }
}

- (void)startCloudAnimation {
    SKAction *nearMove = [SKAction moveByX:-(self.size.width + 2 * self.nearCloud.size.width) y:0 duration:15];
    SKAction *nearDone = [SKAction runBlock:^{
        self.nearCloud.position = CGPointMake(self.size.width + self.nearCloud.size.width,
                                              self.nearCloud.position.y);
    }];
    SKAction *nearAction = [SKAction sequence:@[nearMove, nearDone]];
    [self.nearCloud runAction:[SKAction repeatActionForever:nearAction]];
    
    SKAction *farMove = [SKAction moveByX:-(self.size.width + 2 * self.farCloud.size.width) y:0 duration:20];
    SKAction *farDone = [SKAction runBlock:^{
        self.farCloud.position = CGPointMake(self.size.width + self.farCloud.size.width,
                                             self.farCloud.position.y);
    }];
    SKAction *farAction = [SKAction sequence:@[farMove, farDone]];
    [self.farCloud runAction:[SKAction repeatActionForever:farAction]];
}

- (void)setButtonSelectState:(NSString *)buttonName {
    NSString *name = buttonName;
    if (!name) {
        name = @"non";
    }
    for (HSButtonSprite *button in self.buttons) {
        button.selected = [button.name isEqualToString:name];
    }
}

- (void)setWorldPosition:(CGFloat)positionX {
    SKNode *layer = self.layers[GSWorldLayerGround];
    layer.position = CGPointMake(positionX, layer.position.y);
    SKNode *layer2 = self.layers[GSWorldLayerEnvironment];
    layer2.position = layer.position;
}

#pragma mark - Actions
- (void)clickBack:(id)sender {
    VersionSeletionScene *scene = [[VersionSeletionScene alloc] initWithSize:self.size];
    [self.view presentScene:scene];
}

- (void)showAbout {
    AboutScene *aboutScene = [AboutScene sceneFromNib];
    [aboutScene showInView:self.view];
}

#pragma mark - Class Function
+ (void)loadAssets {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"GameSelect" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    for (NSDictionary *dict in array) {
        NSString *className = dict[@"animal"];
        [NSClassFromString(className) loadAssets];
    }
    
    [HSCrab loadAssets];
}

#pragma mark - Loop
- (void)update:(NSTimeInterval)currentTime {
    for (HSAnimal *animal in self.animals) {
        [animal updateWithTimeSinceLastUpdate:currentTime];
    }
}

#pragma mark - UITouches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.worldMoved = NO;
    UITouch *touch = [touches anyObject];
    self.lastLoc = [touch locationInNode:self];
    
    SKNode *node = [self nodeAtPoint:self.lastLoc];
    [self setButtonSelectState:node.name];
    
    if ([node.name isEqualToString:kBackgroundMusicBtn]) {
        HSButtonSprite *btn = (HSButtonSprite *)node;
        btn.selected = !btn.selected;
        [SettingMgr sharedInstance].bgMusicOff = btn.selected;
        if ([SettingMgr sharedInstance].bgMusicOff) {
            [[SettingMgr sharedInstance] stopBackgroundMusic];
        }
        else {
            [[SettingMgr sharedInstance] startBackgroundMusicWithName:@"game_select_bg.wav"];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    self.worldMoved = YES;
    UITouch *touch = [touches anyObject];
    CGPoint loc = [touch locationInNode:self];
    
    SKNode *layer = self.layers[GSWorldLayerGround];
    CGFloat x = layer.position.x + loc.x - self.lastLoc.x;

    if (x > 0) {
        x = 0;
    }
    else if (x < -(self.bgSize.width - self.size.width)) {
        x = -(self.bgSize.width - self.size.width);
    }
    
    layer.position = CGPointMake(x, layer.position.y);
    SKNode *layer2 = self.layers[GSWorldLayerEnvironment];
    layer2.position = layer.position;
    self.lastLoc = loc;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setButtonSelectState:nil];
    
    if (self.worldMoved) {
        self.worldMoved = NO;
        SKNode *layer = self.layers[GSWorldLayerGround];
        [GameMgr sharedInstance].lastGameSelectionX = layer.position.x;
        
        return;
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint sceneLoc = [touch locationInNode:self];
    SKNode *buttonNode = [self nodeAtPoint:sceneLoc];
    
    if ([buttonNode.name isEqualToString:kAboutBtn]) {
        [self showAbout];
        
        return;
    }
    else if ([buttonNode.name isEqualToString:kBackBtn]) {
        [self clickBack:buttonNode];
        
        return;
    }
    
    SKNode *layer = self.layers[GSWorldLayerGround];
    CGPoint loc = [touch locationInNode:layer];
    SKNode *node = [layer nodeAtPoint:loc];
    [self optionIsSeletedWithName:[node.name intValue]];
}

@end
