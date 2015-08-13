//
//  SignInSchoolScene.m
//  EasyLSP
//
//  Created by Quan on 15/5/4.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "SignInSchoolScene.h"
#import "LoadingScene.h"
#import "GameSelectScene.h"
#import "VersionSeletionScene.h"
#import "HSButtonSprite.h"
#import "HttpReqMgr.h"
#import "AccountMgr.h"
#import "Reachability.h"
#import "SKScene+EzLearn.h"

#define kSignBtn @"signBtn"
#define kBACK_BUTTON @"BACK_BUTTON"

@interface SignInSchoolScene()<UITextFieldDelegate>

@property (strong, nonatomic) SKLabelNode *character1;
@property (strong, nonatomic) SKLabelNode *character2;
@property (strong, nonatomic) SKLabelNode *character3;
@property (strong, nonatomic) SKSpriteNode *signInBtn;

@property (strong, nonatomic) UITextField *schoolTF;
@property (strong, nonatomic) UITextField *accountTF;

@end

@implementation SignInSchoolScene

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
    
    [self buildUIComponents];
    [self startCharactersAction];
    [self spawnStarsZPosition:1];
}

- (void)willMoveFromView:(SKView *)view {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self destroyUIComponents];
    
    [super willMoveFromView:view];
}

- (void)buildWorld {
    // Background
    SKSpriteNode *backgroundSp = [SKSpriteNode spriteNodeWithImageNamed:@"sign_in_school_bg"];
    backgroundSp.size = self.size;
    backgroundSp.position = CGPointMake(self.size.width / 2, self.size.height / 2);
    backgroundSp.zPosition = 0;
    [self addChild:backgroundSp];
    
    _character1 = [SKLabelNode labelNodeWithFontNamed:FONT_NAME_C];
    _character1.position = [UniversalUtil universaliPadPoint:CGPointMake(190, 595)
                                                 iPhonePoint:CGPointMake(90, 252)
                                                     offsetX:0
                                                     offsetY:0];
    _character1.fontColor = [UIColor whiteColor];
    _character1.fontSize = [UniversalUtil universalFontSize:90.];
    _character1.zPosition = 10;
    [self addChild:_character1];
    
    _character2 = [_character1 copy];
    _character2.position = [UniversalUtil universaliPadPoint:CGPointMake(405, 665)
                                                 iPhonePoint:CGPointMake(192, 280)
                                                     offsetX:0
                                                     offsetY:0];
    _character2.zRotation = -M_PI / 4;
    _character2.fontSize = [UniversalUtil universalFontSize:70.];
    [self addChild:_character2];
    
    _character3 = [_character1 copy];
    _character3.position = [UniversalUtil universaliPadPoint:CGPointMake(820, 130)
                                                 iPhonePoint:CGPointMake(386, 58)
                                                     offsetX:0
                                                     offsetY:0];
    _character3.zRotation = -M_PI / 4;
    [self addChild:_character3];
    
    _signInBtn = [SKSpriteNode spriteNodeWithImageNamed:@"sign_btn_nor"];
//    _signInBtn.position = [UniversalUtil universaliPadPoint:CGPointMake(640, 158)
//                                                iPhonePoint:CGPointMake(300, 66)
//                                                    offsetX:0
//                                                    offsetY:0];
    _signInBtn.position = [UniversalUtil universalPointFromCenter:[GlobalUtil centerInSize:self.size]
                                                           deltaX:128
                                                           deltaY:-226
                                                          offsetX:0
                                                          offsetY:20
                                               alliPhonesSuitable:YES];

    _signInBtn.name = kSignBtn;
    _signInBtn.zPosition = 10;
    [self addChild:_signInBtn];
    
    SKLabelNode *signInLab = [SKLabelNode labelNodeWithFontNamed:FONT_NAME_HP];
    signInLab.text = @"Login";
    signInLab.fontSize = [UniversalUtil universalFontSize:30.];
    signInLab.fontColor = colorRGB(214, 43, 43, 1.);
    signInLab.name = kSignBtn;
    signInLab.position = CGPointMake(signInLab.position.x, signInLab.position.y - 7);
    signInLab.zPosition = _signInBtn.zPosition + 1;
    [_signInBtn addChild:signInLab];
    
    SKLabelNode *enAppName = [SKLabelNode labelNodeWithFontNamed:FONT_NAME_HP];
    enAppName.fontSize = [UniversalUtil universalFontSize:68.];
    enAppName.fontColor = colorRGB(214, 43, 43, 1.);
    enAppName.text = @"Easy Learning Island";
    enAppName.position = [UniversalUtil universalPointFromCenter:[GlobalUtil centerInSize:self.size]
                                                          deltaX:0
                                                          deltaY:0
                                                         offsetX:0
                                                         offsetY:0];
    [self addChild:enAppName];
    
    SKLabelNode *cnAppName = [SKLabelNode labelNodeWithFontNamed:FONT_NAME_JCY];
    cnAppName.fontSize = [UniversalUtil universalFontSize:70.];
    cnAppName.fontColor = colorRGB(255, 248, 189, 1.);
    cnAppName.text = @"易学岛";
    cnAppName.position = [UniversalUtil universalPointFromCenter:[GlobalUtil centerInSize:self.size]
                                                          deltaX:-227
                                                          deltaY:60
                                                         offsetX:5
                                                         offsetY:2
                                              alliPhonesSuitable:YES];

    [self addChild:cnAppName];
    
    SKLabelNode *schoolIDPrompt = [SKLabelNode labelNodeWithFontNamed:FONT_NAME_HP];
    schoolIDPrompt.fontSize = [UniversalUtil universalFontSize:25.];
    schoolIDPrompt.fontColor = [UIColor whiteColor];
    schoolIDPrompt.text = @"Get it from your school";
//    schoolIDPrompt.position = CGPointMake(self.size.width / 2 + 10, self.size.height / 2 - 66);
    schoolIDPrompt.position = [UniversalUtil universalPointFromCenter:[GlobalUtil centerInSize:self.size]
                                                               deltaX:10
                                                               deltaY:-66
                                                              offsetX:0
                                                              offsetY:3
                                                   alliPhonesSuitable:YES];
    [self addChild:schoolIDPrompt];
    
    HSButtonSprite *backNode = [[HSButtonSprite alloc] initWithTitle:nil
                                                            norImage:@"back_nor"
                                                            selImage:@"back_sel"];
    backNode.position = [UniversalUtil universaliPadPoint:CGPointMake(100, 100)
                                              iPhonePoint:CGPOINT_NON
                                                  offsetX:0
                                                  offsetY:0];
    backNode.name = kBACK_BUTTON;
    [self addChild:backNode];
}

- (void)buildUIComponents {
    if (!_accountTF) {
        _accountTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, [UniversalUtil universalDelta:200], [UniversalUtil universalDelta:80])];
//        _accountTF.center = CGPointMake(self.size.width / 2 - 50, self.size.height / 2 + 228);
        _accountTF.center = [UniversalUtil universalPointFromCenter:[GlobalUtil centerInSize:self.size]
                                                             deltaX:-50
                                                             deltaY:228
                                                            offsetX:0
                                                            offsetY:18
                                                 alliPhonesSuitable:YES];
        _accountTF.font = [UIFont fontWithName:FONT_NAME_HP size:[UniversalUtil universalFontSize:30.]];
        _accountTF.textColor = [UIColor redColor];
        _accountTF.placeholder = @"UserName";
        _accountTF.delegate = self;
    }
    
    if (![self.view.subviews containsObject:_accountTF]) {
        [self.view addSubview:_accountTF];
    }
    
    if (!_schoolTF) {
        _schoolTF = [[UITextField alloc] initWithFrame:CGRectMake(_accountTF.frame.origin.x, 0, [UniversalUtil universalDelta:320], [UniversalUtil universalDelta:80])];
//        _schoolTF.center = CGPointMake(self.size.width / 2 - 50, self.size.height / 2 + 110);
        _schoolTF.center = [UniversalUtil universalPointFromCenter:[GlobalUtil centerInSize:self.size]
                                                            deltaX:9
                                                            deltaY:110
                                                           offsetX:0
                                                           offsetY:8
                                                alliPhonesSuitable:YES];
        CGRect frame = _schoolTF.frame;
        frame.origin.x = _accountTF.frame.origin.x;
        _schoolTF.frame = frame;
        _schoolTF.font = [UIFont fontWithName:FONT_NAME_HP size:[UniversalUtil universalFontSize:30.]];
        _schoolTF.textColor = [UIColor redColor];
        _schoolTF.placeholder = @"School ID";
        _schoolTF.delegate = self;
        
        if ([SettingMgr getValueForKey:KEY_SCHOOL_ID]) {
            _schoolTF.text = [SettingMgr getValueForKey:KEY_SCHOOL_ID];
        }
    }
    
    if (![self.view.subviews containsObject:_schoolTF]) {
        [self.view addSubview:_schoolTF];
    }
}

- (void)changeCharacters {
    self.character1.text = [GlobalUtil randomCharacter];
    self.character2.text = [GlobalUtil randomCharacter];
    self.character3.text = [GlobalUtil randomCharacter];
}

- (void)destroyUIComponents {
    [self.accountTF removeFromSuperview];
    [self.schoolTF removeFromSuperview];
}

- (void)goToGameSelect {
    [self.accountTF resignFirstResponder];
    [self.schoolTF resignFirstResponder];
    GameSelectScene *scene = [[GameSelectScene alloc] initWithSize:self.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [LoadingScene dismissTo:scene];
}

- (void)startCharactersAction {
    SKAction *changeAction = [SKAction runBlock:^{
        [self changeCharacters];
    }];
    SKAction *waitAction = [SKAction waitForDuration:0.8];
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[changeAction, waitAction]]] withKey:@"ChangeCharacters"];
}

#pragma mark - Actions
- (void)clickSignIn:(id)sender {
    [self.accountTF resignFirstResponder];
    [self.schoolTF resignFirstResponder];
    
    if (self.accountTF.text.length > 0) {
        [LoadingScene showFrom:self];
        
        __block NSString *errorMsg = nil;
        dispatch_group_t group = dispatch_group_create();
        
        dispatch_group_enter(group);
        [HttpReqMgr requestGetServerUrl:self.schoolTF.text
                               IPAdress:[Reachability getIPAddress]
                             completion:^(NSDictionary *info) {
                                 [SettingMgr setValue:self.schoolTF.text withKey:KEY_SCHOOL_ID];
                                 dispatch_group_leave(group);
                             } failure:^(HSError *error) {
//                                 errorMsg = error.message;
                                 dispatch_group_leave(group);
                             }];
        
        dispatch_group_enter(group);
        [HttpReqMgr requestCheckUser:self.accountTF.text
                          completion:^(NSDictionary *info) {
                              [AccountMgr sharedInstance].user.name = self.accountTF.text;
                              dispatch_group_leave(group);
                          } failure:^(HSError *error) {
                              errorMsg = error.message;
                              dispatch_group_leave(group);
                          }];
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            if (errorMsg) {
                [LoadingScene dismissTo:self];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:errorMsg
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK~"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            else {
                [self goToGameSelect];
            }
        });
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

- (void)clickBack:(SKNode *)button {
    [self.accountTF resignFirstResponder];
    [self.schoolTF resignFirstResponder];
    
    VersionSeletionScene *scene = [[VersionSeletionScene alloc] initWithSize:self.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [self.view presentScene:scene];
}

#pragma mark - UITextField
- (BOOL)textFieldShouldReturn:(nonnull UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - Notification
- (void)handleKeyboardShow:(NSNotification *)notification {
    UITextField *textField = notification.object;
    NSDictionary *dict = notification.userInfo;
    CGRect frame = [dict[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [dict[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat height = frame.size.height - (self.view.frame.size.height - textField.frame.origin.y - textField.frame.size.height);
    if (self.view.frame.size.width < self.view.frame.size.height) {
        height = frame.size.width - (self.view.frame.size.width - textField.frame.origin.y - textField.frame.size.height);
    }
    
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = self.view.frame;
        if (self.view.frame.size.width > self.view.frame.size.height) {
            frame.origin.y = height;
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
    else if ([node.name isEqualToString:kBACK_BUTTON]) {
        [self clickBack:node];
    }
    else {
        self.signInBtn.texture = [SKTexture textureWithImageNamed:@"sign_btn_nor"];
        [self.accountTF resignFirstResponder];
        [self.schoolTF resignFirstResponder];
    }
}

@end
