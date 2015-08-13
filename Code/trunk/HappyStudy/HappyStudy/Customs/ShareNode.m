//
//  ShareNode.m
//  EasyLSP
//
//  Created by Q on 15/6/3.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "ShareNode.h"
#import "HSButtonSprite.h"
#import "HSOwl.h"
#import "AccountMgr.h"
#import "GameMgr.h"
#import "HttpReqMgr.h"
#import "WXApi.h"

#import <TencentOpenAPI/TencentOAuth.h>

#define kSHARE_NODE @"SHARE_NODE"

#define kTWITTER_BUTTON @"TWITTER_BUTTON"
#define kWEIBO_BUTTON @"WEIBO_BUTTON"
#define kFACEBOOK_BUTTON @"FACEBOOK_BUTTON"
#define kWEIXIN_BUTTON @"WEIXIN_BUTTON"
#define kQQ_BUTTON @"QQ_BUTTON"
#define kCLOSE_BUTTON @"CLOSE_BUTTON"

@interface ShareNode()

@property (strong, nonatomic) NSString *shareText;
@property (strong, nonatomic) UIImage *shareImg;

@end

@implementation ShareNode

- (instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithColor:[UIColor colorWithWhite:0 alpha:0.7] size:size]) {
        [self build];
    }
    
    return self;
}

- (void)doShareWithType:(ShareType)type {
    if (!self.getShareContentBlock) {
        return;
    }
    
    self.type = type;
    self.getShareContentBlock(type);
}

- (void)doShareWithType:(ShareType)type text:(NSString *)text image:(UIImage *)image url:(NSURL *)url {
    self.shareText = text;
    self.shareImg = image;
    
    ShareUtil *shareUtil = [ShareUtil sharedInstance];
    [shareUtil shareWithType:type
                        text:self.shareText
                       image:self.shareImg
                         url:nil
             completeHandler:^(BOOL success) {
                 [self shareCompletion:success];
             }];
}

- (void)hideShare {
    [self removeFromParent];
}

- (BOOL)handleNodeName:(NSString *)name {
    BOOL rel = NO;
    
    if (!self.parent) {
        return rel;
    }
    
    if ([name isEqualToString:kTWITTER_BUTTON]) {
        rel = YES;
        [self clickTwitter:nil];
    }
    else if ([name isEqualToString:kWEIBO_BUTTON]) {
        rel = YES;
        [self clickWeibo:nil];
    }
    else if ([name isEqualToString:kFACEBOOK_BUTTON]) {
        rel = YES;
        [self clickFacebook:nil];
    }
    else if ([name isEqualToString:kWEIXIN_BUTTON]) {
        rel = YES;
        [self clickWeixin:nil];
    }
    else if ([name isEqualToString:kWEIBO_BUTTON]) {
        rel = YES;
        [self clickWeibo:nil];
    }
    else if ([name isEqualToString:kQQ_BUTTON]) {
        rel = YES;
        [self clickQQ:nil];
    }
    else if ([name isEqualToString:kCLOSE_BUTTON]) {
        rel = YES;
        if (self.delegate && [self.delegate respondsToSelector:@selector(didClickClose:)]) {
            [self.delegate didClickClose:self];
        }
    }
    
    return rel;
}

- (BOOL)isShareNodeWithName:(NSString *)name {
    if (!name) {
        return NO;
    }
    
    return [name isEqualToString:self.name];
}

- (void)build {
    self.position = CGPointZero;
    self.anchorPoint = CGPointZero;
    self.name = kSHARE_NODE;
    
    SKSpriteNode *backgroundSp = [SKSpriteNode spriteNodeWithImageNamed:@"common_alert_bg"];
    backgroundSp.position = CGPointMake(self.size.width / 2 - backgroundSp.size.width / 2,
                                        self.size.height / 2 - backgroundSp.size.height / 2);
    backgroundSp.anchorPoint = CGPointZero;
    [self addChild:backgroundSp];
    
    SKLabelNode *titleLab = [SKLabelNode labelNodeWithFontNamed:FONT_NAME_HP];
    titleLab.text = @"分享";
    titleLab.position = CGPointMake(backgroundSp.size.width / 2, backgroundSp.size.height - [UniversalUtil universalDelta:100]);
    titleLab.fontSize = [UniversalUtil universalFontSize:25];
    titleLab.fontName = FONT_NAME_HP;
    titleLab.fontColor = colorRGB(191, 98, 35, 1);
    [backgroundSp addChild:titleLab];
    
    // Buttons
    HSButtonSprite *twitterBtn = [[HSButtonSprite alloc] initWithTitle:@""
                                                              norImage:@"twitter"
                                                              selImage:@"twitter"];
    twitterBtn.name = kTWITTER_BUTTON;
    twitterBtn.position = CGPointMake(backgroundSp.size.width / 2 - [UniversalUtil universalDelta:155],
                                      titleLab.position.y - [UniversalUtil universalDelta:60]);
    [backgroundSp addChild:twitterBtn];
    
    SKLabelNode *twitterLab = [SKLabelNode labelNodeWithFontNamed:FONT_NAME_HP];
    twitterLab.text = @"twitter";
    twitterLab.position = CGPointMake(twitterBtn.position.x,
                                      twitterBtn.position.y - [UniversalUtil universalDelta:70]);
    twitterLab.fontSize = [UniversalUtil universalFontSize:25];
    twitterLab.fontName = FONT_NAME_HP;
    twitterLab.fontColor = colorRGB(191, 98, 35, 1);
    [backgroundSp addChild:twitterLab];
    
    HSButtonSprite *weiboBtn = [[HSButtonSprite alloc] initWithTitle:@""
                                                            norImage:@"weibo"
                                                            selImage:@"weibo"];
    weiboBtn.name = kWEIBO_BUTTON;
    weiboBtn.position = CGPointMake(backgroundSp.size.width / 2, twitterBtn.position.y);
    [backgroundSp addChild:weiboBtn];
    
    SKLabelNode *weiboLab = [SKLabelNode labelNodeWithFontNamed:FONT_NAME_HP];
    weiboLab.text = @"新浪微博";
    weiboLab.fontSize = [UniversalUtil universalFontSize:25];
    weiboLab.fontName = FONT_NAME_HP;
    weiboLab.fontColor = colorRGB(191, 98, 35, 1);
    weiboLab.position = CGPointMake(weiboBtn.position.x,
                                    twitterLab.position.y);
    [backgroundSp addChild:weiboLab];
    
    HSButtonSprite *facebookBtn = [[HSButtonSprite alloc] initWithTitle:@""
                                                               norImage:@"facebook"
                                                               selImage:@"facebook"];
    facebookBtn.name = kFACEBOOK_BUTTON;
    facebookBtn.position = CGPointMake(backgroundSp.size.width / 2 + [UniversalUtil universalDelta:155], twitterBtn.position.y);
    [backgroundSp addChild:facebookBtn];
    
    SKLabelNode *facebookLab = [SKLabelNode labelNodeWithFontNamed:FONT_NAME_HP];
    facebookLab.text = @"Facebook";
    facebookLab.fontSize = [UniversalUtil universalFontSize:25];
    facebookLab.fontName = FONT_NAME_HP;
    facebookLab.fontColor = colorRGB(191, 98, 35, 1);
    facebookLab.position = CGPointMake(facebookBtn.position.x,
                                       twitterLab.position.y);
    [backgroundSp addChild:facebookLab];
    
    if ([WXApi isWXAppInstalled]) {
        HSButtonSprite *weixinBtn = [[HSButtonSprite alloc] initWithTitle:@""
                                                                 norImage:@"weixin"
                                                                 selImage:@"weixin"];
        weixinBtn.name = kWEIXIN_BUTTON;
        weixinBtn.position = CGPointMake(backgroundSp.size.width / 2 - [UniversalUtil universalDelta:80],
                                         twitterBtn.position.y - [UniversalUtil universalDelta:140]);
        [backgroundSp addChild:weixinBtn];
        
        SKLabelNode *weixinLab = [SKLabelNode labelNodeWithFontNamed:FONT_NAME_HP];
        weixinLab.text = @"微信";
        weixinLab.fontSize = [UniversalUtil universalFontSize:25];
        weixinLab.fontName = FONT_NAME_HP;
        weixinLab.fontColor = colorRGB(191, 98, 35, 1);
        weixinLab.position = CGPointMake(weixinBtn.position.x,
                                         twitterLab.position.y - [UniversalUtil universalDelta:140]);
        [backgroundSp addChild:weixinLab];
    }
    
    if ([TencentOAuth iphoneQQInstalled]) {
        HSButtonSprite *qqBtn = [[HSButtonSprite alloc] initWithTitle:@""
                                                             norImage:@"qq"
                                                             selImage:@"qq"];
        qqBtn.name = kQQ_BUTTON;
        qqBtn.position = CGPointMake(backgroundSp.size.width / 2 + [UniversalUtil universalDelta:80],
                                     twitterBtn.position.y - [UniversalUtil universalDelta:140]);
        [backgroundSp addChild:qqBtn];
        
        SKLabelNode *qqLab = [SKLabelNode labelNodeWithFontNamed:FONT_NAME_HP];
        qqLab.text = @"QQ";
        qqLab.fontSize = [UniversalUtil universalFontSize:25];
        qqLab.fontName = FONT_NAME_HP;
        qqLab.fontColor = colorRGB(191, 98, 35, 1);
        qqLab.position = CGPointMake(qqBtn.position.x,
                                     twitterLab.position.y - [UniversalUtil universalDelta:140]);
        [backgroundSp addChild:qqLab];
    }
    
    HSButtonSprite *closeBtn = [[HSButtonSprite alloc] initWithTitle:nil
                                                            norImage:@"about_close.png"
                                                            selImage:@"about_close.png"];
    closeBtn.name = kCLOSE_BUTTON;
    closeBtn.zPosition = 1000;
    closeBtn.position = CGPointMake(backgroundSp.size.width - [UniversalUtil universalDelta:6],
                                    backgroundSp.size.height - [UniversalUtil universalDelta:20]);
    [backgroundSp addChild:closeBtn];
    
    // Character
    HSAnimal *owl = [[HSOwl alloc] initWithTexture:nil];
    [HSOwl loadAssets];
    owl.zRotation = -M_PI / 12;
    owl.zPosition = 10;
    owl.position = CGPointMake(backgroundSp.size.width / 2,
                               backgroundSp.size.height - [UniversalUtil universalDelta:20]);
    [backgroundSp addChild:owl];
    SKAction *idleAction = [SKAction animateWithTextures:[owl idleAnimationFrames]
                                            timePerFrame:1 / 5.];
    [owl runAction:[SKAction repeatActionForever:idleAction]];
}

- (void)shareCompletion:(BOOL)success {
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareNode:didFinishShare:)]) {
        [self.delegate shareNode:self didFinishShare:success];
    }
}

- (void)showInNode:(SKNode *)node {
    self.zPosition = 100000;
    [node addChild:self];
}

#pragma mark - Actions
- (void)clickTwitter:(SKNode *)node {
    [self doShareWithType:ShareTypeTwitter];
}

- (void)clickWeibo:(SKNode *)node {
    [self doShareWithType:ShareTypeWeibo];
}

- (void)clickFacebook:(SKNode *)node {
    [self doShareWithType:ShareTypeFacebook];
}

- (void)clickWeixin:(SKNode *)node {
    [self doShareWithType:ShareTypeWeixin];
}

- (void)clickQQ:(SKNode *)node {
    [self doShareWithType:ShareTypeQQ];
}

@end
