//
//  GameSelectIndividualScene.m
//  EasyLSP
//
//  Created by Q on 15/5/15.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "GameSelectIndividualScene.h"
#import "VersionSeletionScene.h"
#import "HSCharacter.h"
#import "ShareNode.h"
#import "CupScene.h"
#import "AboutScene.h"
#import "AccountMgr.h"
#import "HttpReqMgr.h"
#import "Award.h"

#define kCupBtn @"CupBtn"
#define kSCORE_BUTTON @"SCORE_BUTTON"
#define kSHARE_SCORE @"SHARE_SCORE"
#define kSHARE_CUP @"SHARE_CUP"
#define kPARENT @"PARENT"

@interface GameSelectIndividualScene()<ShareNodeDelegate, CupSceneDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) ShareNode *shareNode;
@property (strong, nonatomic) CupScene *cupScene;
@property (strong, nonatomic) HSLabelSprite *cupNotify;

@property (strong, nonatomic) Task *toShareTask;
@property (strong, nonatomic) NSArray *lockedGames;

@end

@implementation GameSelectIndividualScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.lockedGames = @[[NSString stringWithFormat:@"%@", @(StudyGamePengPengDaCi)],
                             [NSString stringWithFormat:@"%@", @(StudyGameJuZiQiao)]];
    }
    
    return self;
}

- (void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshCupInfo)
                                                 name:kNOTIFICATION_REFRESH_CUP_INFO
                                               object:nil];
    
    [self refreshCupInfo];
}

- (void)willMoveFromView:(SKView *)view {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kNOTIFICATION_REFRESH_CUP_INFO
                                                  object:nil];
}

- (void)refreshCupInfo {
    self.cupNotify.alpha = ([AccountMgr sharedInstance].awards.count > 0 || [AccountMgr sharedInstance].tasks.count > 0) ? 1.0 : 0.0;
    
    if (self.cupScene && [self.cupScene isShowing]) {
        [self refreshCupInfo];
    }
}

- (void)showCup {
    if (!self.cupScene) {
        self.cupScene = [CupScene sceneFromNib];
        self.cupScene.delegate = self;
    }
    
    [self.cupScene showInView:self.view];
}

- (void)showShare {
    if (![GlobalUtil isNetworkConnection]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Check your internet connection"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    if (!self.shareNode) {
        self.shareNode = [[ShareNode alloc] initWithSize:self.size];
        self.shareNode.delegate = self;
    }
    
    self.shareNode.name = kSHARE_SCORE;
    
    GetShareContent block = ^(ShareType type) {
        [HttpReqMgr requestGetAppShareContent:[AccountMgr sharedInstance].user.name
                                        score:[AccountMgr sharedInstance].user.score
                                     playTime:[AccountMgr sharedInstance].user.playTime
                                   completion:^(NSDictionary *info) {
                                       NSString *content = info[@"ShareText"];
                                       [self.shareNode doShareWithType:type
                                                                  text:content
                                                                 image:nil
                                                                   url:nil];
                                   } failure:^(HSError *error) {
                                       [self shareNode:self.shareNode didFinishShare:NO];
                                   }];
    };
    
    self.shareNode.getShareContentBlock = block;
    [self.shareNode showInNode:self];
}

- (void)showCupShare:(Task *)task {
    if (!self.shareNode) {
        self.shareNode = [[ShareNode alloc] initWithSize:self.size];
        self.shareNode.delegate = self;
    }
    
    self.toShareTask = task;
    self.shareNode.name = kSHARE_CUP;
    
    GetShareContent block = ^(ShareType type) {
        [HttpReqMgr requestGetCupShareContent:[AccountMgr sharedInstance].user.name
                                   identifier:task.identifier
                                      shareID:[NSString stringWithFormat:@"%@", @(type)]
                                         type:[task isKindOfClass:[Award class]] ? 0 : 1
                                   completion:^(NSDictionary *info) {
                                       NSString *content = info[@"ShareText"];
                                       [self.shareNode doShareWithType:type
                                                                  text:content
                                                                 image:nil
                                                                   url:nil];
                                   } failure:^(HSError *error) {
                                       [self shareNode:self.shareNode didFinishShare:NO];
                                   }];
    };
    
    self.shareNode.getShareContentBlock = block;
    [self.shareNode showInNode:self];

    self.cupScene.hidden = YES;
}

- (void)showParent {
    AboutScene *aboutScene = [AboutScene sceneFromNib];
    aboutScene.textView.text = @"To track your Child’s learning progress and performance, please register at  http://52.74.225.18/reg/";
    aboutScene.titleLabel.text = @"Parent";
    [aboutScene showInView:self.view];
}

#pragma mark - Override
- (void)addGameOptions {
    [super addGameOptions];
    
    for (NSString *game in self.lockedGames) {
        for (HSCharacter *animal in self.animals) {
            if ([game isEqualToString:animal.name]) {
                animal.alpha = 0.0;
                SKSpriteNode *lockSprite = [SKSpriteNode spriteNodeWithImageNamed:@"lock"];
                lockSprite.position = animal.position;
                [self addNode:lockSprite atWorldLayer:GSWorldLayerGround];
                
                break;
            }
        }
        
        for (SKLabelNode *label in self.options) {
            if ([game isEqualToString:label.name]) {
                label.fontColor = colorRGB(235, 200, 145, 1);
                
                break;
            }
        }
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
    scoreNode.name = kSCORE_BUTTON;
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
    backNode.position = [UniversalUtil universaliPadPoint:CGPointMake(673, 693)
                                              iPhonePoint:CGPOINT_NON
                                                  offsetX:0
                                                  offsetY:-60];
    backNode.name = kBackBtn;
    [self addNode:backNode atWorldLayer:GSWorldLayerTop];
    [self.buttons addObject:backNode];
    
    HSButtonSprite *bgMusicSwitch = [[HSButtonSprite alloc] initWithTitle:nil
                                                                 norImage:@"music_on"
                                                                 selImage:@"music_off"];
    bgMusicSwitch.position = CGPointMake(self.size.width - [UniversalUtil universalDelta:113], [UniversalUtil universalDelta:20]);
    bgMusicSwitch.anchorPoint = CGPointZero;
    bgMusicSwitch.name = kBackgroundMusicBtn;
    bgMusicSwitch.selected = [SettingMgr sharedInstance].bgMusicOff;
    [self addNode:bgMusicSwitch atWorldLayer:GSWorldLayerTop];
    
    HSButtonSprite *cupNode = [[HSButtonSprite alloc] initWithTitle:@""
                                                           norImage:@"cup"
                                                           selImage:@"cup"];
    cupNode.name = kCupBtn;
    cupNode.position = [UniversalUtil universaliPadPoint:CGPointMake(394, 693)
                                             iPhonePoint:CGPOINT_NON
                                                 offsetX:0
                                                 offsetY:-60];
    [self addNode:cupNode atWorldLayer:GSWorldLayerTop];
    [self.buttons addObject:cupNode];
    
    self.cupNotify = [[HSLabelSprite alloc] initWithTexture:nil title:0];
    self.cupNotify.zPosition = 10;
    self.cupNotify.position = CGPointMake(cupNode.position.x + cupNode.size.width / 2,
                                          cupNode.position.y + cupNode.size.height / 2);
    self.cupNotify.alpha = 0.0;
    self.cupNotify.color = [UIColor redColor];
    [self addNode:self.cupNotify atWorldLayer:GSWorldLayerTop];
    
    HSButtonSprite *parentNode = [[HSButtonSprite alloc] initWithTitle:@"Parent"
                                                              norImage:@"about_btn_nor"
                                                              selImage:@"about_btn_sel"];
    parentNode.name = kPARENT;
    parentNode.position = [UniversalUtil universaliPadPoint:CGPointMake(540, 693)
                                               iPhonePoint:CGPOINT_NON
                                                   offsetX:0
                                                   offsetY:-60];
    parentNode.label.fontSize = [UniversalUtil universalFontSize:23.];
    parentNode.label.fontName = FONT_NAME_HP;
    [self addNode:parentNode atWorldLayer:GSWorldLayerTop];
    [self.buttons addObject:parentNode];
}

- (void)clickBack:(id)sender {
    VersionSeletionScene *scene = [[VersionSeletionScene alloc] initWithSize:self.size];
    [self.view presentScene:scene];
}

- (void)optionIsSeletedWithName:(StudyGame)studyGame {
    for (NSString *game in self.lockedGames) {
        StudyGame theGame = (StudyGame)[game integerValue];
        if (theGame == studyGame) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"contact your school /tuition centre to purchase\nInput Your School/Tuition Centre Name to Unlock:"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"OK", nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alert show];
            
            return;
        }
    }
    
    [super optionIsSeletedWithName:studyGame];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setButtonSelectState:nil];
    
    UITouch *touch = [touches anyObject];
    CGPoint sceneLoc = [touch locationInNode:self];
    SKNode *buttonNode = [self nodeAtPoint:sceneLoc];
    
    if ([buttonNode.name isEqualToString:kCupBtn]) {
        [self showCup];
        
        return;
    }
    else if ([buttonNode.name isEqualToString:kSCORE_BUTTON]) {
        [self showShare];
        
        return;
    }
    else if ([buttonNode.name isEqualToString:kPARENT]) {
        [self showParent];
        
        return;
    }
    
    if ([self.shareNode handleNodeName:buttonNode.name]) {
        return;
    }
    
    [super touchesEnded:touches withEvent:event];
}

#pragma mark - UIAlertView
- (void)alertView:(nonnull UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        [HttpReqMgr requestSubmitSchoolInfo:[AccountMgr sharedInstance].user.name
                                 schoolName:textField.text
                                 completion:^(NSDictionary *info) {
                                     
                                 } failure:^(HSError *error) {
                                     
                                 }];
    }
}

#pragma mark - ShareNodeDelegate
- (void)shareNode:(ShareNode *)shareNode didFinishShare:(BOOL)success {
    [shareNode hideShare];
    
    NSString *errorMsg = @"分享失败";
    if ([shareNode.name isEqualToString:kSHARE_CUP]) {
        self.cupScene.hidden = NO;
        errorMsg = @"兑换失败";
    }
    
    if (!success) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:errorMsg
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else if ([shareNode.name isEqualToString:kSHARE_CUP]) {
        [HttpReqMgr requestRedeemCup:[AccountMgr sharedInstance].user.name
                          identifier:self.toShareTask.identifier
                             shareID:[NSString stringWithFormat:@"%@", @(shareNode.type)]
                                type:[self.toShareTask isKindOfClass:[Award class]] ? 0 : 1
                          completion:^(NSDictionary *info) {
                              [self.cupScene reloadInfos];
                          } failure:^(HSError *error) {
                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                              message:errorMsg
                                                                             delegate:nil
                                                                    cancelButtonTitle:@"OK"
                                                                    otherButtonTitles:nil];
                              [alert show];
                          }];
    }
}

- (void)didClickClose:(ShareNode *)shareNode {
    [shareNode hideShare];
    
    if ([shareNode.name isEqualToString:kSHARE_CUP]) {
        self.cupScene.hidden = NO;
    }
}

#pragma mark - CupScene
- (void)cupScene:(CupScene *)cupScene didClickExchange:(Task *)task {
    [self showCupShare:task];
}

@end
