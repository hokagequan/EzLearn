//
//  SignInScene.m
//  HappyStudy
//
//  Created by Q on 14/10/23.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "SignInScene.h"
#import "GameSelectScene.h"
#import "LoadingScene.h"
#import "GlobalUtil.h"
#import "HttpReqMgr.h"
#import "AccountMgr.h"
#import "AppDelegate.h"

#define kSignBtn @"signBtn"

typedef enum {
    ZPosBG = 0,
    ZPosCharacter = 100,
    ZPosAboveCharacter = 200,
}ZPos;

@interface SignInScene ()

@property (strong, nonatomic) SKSpriteNode *signInBtn;
@property (strong, nonatomic) UITextField *accountTF;
@property (strong, nonatomic) SKLabelNode *character1;
@property (strong, nonatomic) SKLabelNode *character2;
@property (strong, nonatomic) SKLabelNode *character3;
@property (strong, nonatomic) SKTextureAtlas *environmentAtlas;

@end

@implementation SignInScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        [self buildWorld];
    }
    
    return self;
}

- (void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardShow:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    if (!_accountTF) {
        _accountTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 80)];
        _accountTF.center = CGPointMake(self.size.width / 2 - 50, self.size.height / 2 + 160);
        _accountTF.font = [UIFont fontWithName:FONT_NAME_HP size:30.];
        _accountTF.textColor = [UIColor redColor];
        _accountTF.placeholder = @"UserName";
    }
    
    if (![self.view.subviews containsObject:_accountTF]) {
        [self.view addSubview:_accountTF];
    }
    
    [self playBackgroundMusic];
    [self spawnStars];
    [self startCharactersAction];
}

- (void)willMoveFromView:(SKView *)view {
    [self.accountTF removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeActionForKey:@"SpawnStars"];
    [self removeActionForKey:@"ChangeCharacters"];
    
    [super willMoveFromView:view];
}

- (void)addStar {
    // 随即大小
    CGFloat standardSize = 20.;
    int minScale = 1.0 * standardSize;
    int maxScale = 2.0 * standardSize;
    int randomScale = (arc4random() % (maxScale - minScale)) + minScale;
    // 随即位置
    int minX = randomScale / 2;
    int maxX = self.size.width - randomScale / 2;
    int randomX = (arc4random() % (maxX - minX)) + minX;
    // 随即时间
    int minDuration = 3;
    int maxDuration = 6;
    int randomDuration = (arc4random() % (maxDuration - minDuration)) + minDuration;
    
    SKSpriteNode *star = [SKSpriteNode spriteNodeWithTexture:[self.environmentAtlas textureNamed:@"bubble"]
                                                        size:CGSizeMake(randomScale, randomScale)];
    star.position = CGPointMake(randomX, -(randomScale + 50));
    star.zPosition = ZPosAboveCharacter;
    [self addChild:star];
    
    SKAction *rotateOnceAction = [SKAction rotateByAngle:2 * M_PI duration:1.];
    SKAction *rotateAction = [SKAction repeatActionForever:rotateOnceAction];
    [star runAction:rotateAction];
    SKAction *moveAction = [SKAction moveByX:0. y:self.size.height + 50 + randomScale duration:randomDuration];
    SKAction *doneAction = [SKAction runBlock:^{
        [star removeFromParent];
    }];
    
    [star runAction:[SKAction sequence:@[moveAction, doneAction]]];
}

- (void)buildWorld {
    _environmentAtlas = [SKTextureAtlas atlasNamed:@"Environment"];
    
    SKSpriteNode *bgNode = [SKSpriteNode spriteNodeWithImageNamed:@"signin_bg"];
    bgNode.size = self.size;
    bgNode.position = CGPointMake(self.size.width / 2, self.size.height / 2);
    bgNode.zPosition = ZPosBG;
    [self addChild:bgNode];
    
    _signInBtn = [SKSpriteNode spriteNodeWithImageNamed:@"sign_btn_nor"];
    _signInBtn.position = CGPointMake(640, 226);
    _signInBtn.name = kSignBtn;
    _signInBtn.zPosition = ZPosCharacter;
    [self addChild:_signInBtn];
    
    SKLabelNode *signInLab = [SKLabelNode labelNodeWithFontNamed:FONT_NAME_HP];
    signInLab.text = @"Login";
    signInLab.fontSize = 30.;
    signInLab.fontColor = colorRGB(214, 43, 43, 1.);
    signInLab.name = kSignBtn;
    signInLab.position = CGPointMake(signInLab.position.x, signInLab.position.y - 10);
    signInLab.zPosition = _signInBtn.zPosition + 1;
    [_signInBtn addChild:signInLab];
    
    _character1 = [SKLabelNode labelNodeWithFontNamed:FONT_NAME_C];
    _character1.position = CGPointMake(190, 595);
    _character1.fontColor = [UIColor whiteColor];
    _character1.fontSize = 90.;
    _character1.zPosition = ZPosCharacter;
    [self addChild:_character1];
    
    _character2 = [_character1 copy];
    _character2.position = CGPointMake(405, 665);
    _character2.zRotation = -M_PI / 4;
    _character2.fontSize = 70.;
    [self addChild:_character2];
    
    _character3 = [_character1 copy];
    _character3.position = CGPointMake(820, 130);
    _character3.zRotation = -M_PI / 4;
    [self addChild:_character3];
    
    SKLabelNode *enAppName = [SKLabelNode labelNodeWithFontNamed:FONT_NAME_HP];
    enAppName.fontSize = 68.;
    enAppName.fontColor = colorRGB(214, 43, 43, 1.);
    enAppName.text = @"Easy Learning Island";
    enAppName.zPosition = ZPosCharacter;
    enAppName.position = CGPointMake(self.size.width / 2, self.size.height / 2 - 28);
    [self addChild:enAppName];
    
    SKLabelNode *cnAppName = [SKLabelNode labelNodeWithFontNamed:FONT_NAME_JCY];
    cnAppName.fontSize = 70.;
    cnAppName.fontColor = colorRGB(255, 248, 189, 1.);
    cnAppName.text = @"易学岛";
    cnAppName.zPosition = ZPosCharacter;
    cnAppName.position = CGPointMake(285, self.size.height / 2 + 30);
    [self addChild:cnAppName];
}

- (void)changeCharacters {
    self.character1.text = [GlobalUtil randomCharacter];
    self.character2.text = [GlobalUtil randomCharacter];
    self.character3.text = [GlobalUtil randomCharacter];
}

- (void)goToGameSelect {
    [self.accountTF resignFirstResponder];
    GameSelectScene *scene = [[GameSelectScene alloc] initWithSize:self.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [LoadingScene dismissTo:scene];
}

- (void)playBackgroundMusic {
    [[SettingMgr sharedInstance] startBackgroundMusicWithName:@"signIn_bg.mp3"];
}

- (void)spawnStars {
    SKAction *addAction = [SKAction runBlock:^{
        [self addStar];
    }];
    SKAction *waitAction = [SKAction waitForDuration:0.3];
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[addAction, waitAction]]] withKey:@"SpawnStars"];
}

- (void)startCharactersAction {
    SKAction *changeAction = [SKAction runBlock:^{
        [self changeCharacters];
    }];
    SKAction *waitAction = [SKAction waitForDuration:0.8];
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[changeAction, waitAction]]] withKey:@"ChangeCharacters"];
}

#pragma mark - Action
- (void)clickSignIn:(id)sender {
    [self.accountTF resignFirstResponder];
    
//    if (![GlobalUtil isNetworkConnection]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                        message:@"Link to server error, please check your internet connection"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK~"
//                                              otherButtonTitles:nil];
//        [alert show];
//        
//        return;
//    }
    
    if (self.accountTF.text.length > 0) {
        [AccountMgr sharedInstance].user.name = self.accountTF.text;
        [LoadingScene showFrom:self];
        [HttpReqMgr requestCheckUser:self.accountTF.text
                          completion:^(NSDictionary *info) {
                              [self goToGameSelect];
                          } failure:^(HSError *error) {
                              [LoadingScene dismissTo:self];
                              
                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                              message:error.message
                                                                             delegate:nil
                                                                    cancelButtonTitle:@"OK~"
                                                                    otherButtonTitles:nil];
                              [alert show];
                          }];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Please enter user name"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK~"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - Notification
- (void)handleKeyboardShow:(NSNotification *)notification {
    NSDictionary *dict = notification.userInfo;
    CGRect frame = [dict[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [dict[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat height = frame.size.height - (self.view.frame.size.height - self.accountTF.frame.origin.y - self.accountTF.frame.size.height);
    if (self.view.frame.size.width < self.view.frame.size.height) {
        height = frame.size.width - (self.view.frame.size.width - self.accountTF.frame.origin.y - self.accountTF.frame.size.height);
    }
    
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = self.view.frame;
        if (self.view.frame.size.width > self.view.frame.size.height) {
            frame.origin.y = -height;
        }
        else {
            NSInteger dir = [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft ? 1 : -1;
            frame.origin.x = dir * height;
        }
        self.view.frame = frame;
    }];
}

- (void)handleKeyboardHide:(NSNotification *)notification {
    NSDictionary *dict = notification.userInfo;
    CGFloat duration = [dict[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = self.view.frame;
        if (self.view.frame.size.width > self.view.frame.size.height) {
            frame.origin.y = 0;
        }
        else {
            frame.origin.x = 0;
        }
        self.view.frame = frame;
    }];
}

#pragma mark - Touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint loc = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:loc];
    
    if ([node.name isEqualToString:kSignBtn]) {
        self.signInBtn.texture = [SKTexture textureWithImageNamed:@"sign_btn_sel"];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint loc = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:loc];
    
    if ([node.name isEqualToString:kSignBtn]) {
        [self clickSignIn:node];
    }
    else {
        self.signInBtn.texture = [SKTexture textureWithImageNamed:@"sign_btn_nor"];
        [self.accountTF resignFirstResponder];
    }
}

@end
