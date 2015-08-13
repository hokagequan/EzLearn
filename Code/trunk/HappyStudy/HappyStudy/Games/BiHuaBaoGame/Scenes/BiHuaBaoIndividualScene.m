//
//  DaDiShuIndividualScene.m
//  EasyLSP
//
//  Created by Quan on 15/5/8.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "BiHuaBaoIndividualScene.h"
#import "BHBMgr.h"
#import "AccountMgr.h"

#import "GradientView.h"

@interface BiHuaBaoIndividualScene()<UIAlertViewDelegate>

@property (strong, nonatomic) GradientView *lifeView;
@property (strong, nonatomic) UILabel *lifeLab;
@property (strong, nonatomic) UIButton *timeBtn;

@property (nonatomic) CGRect originalLifeFrame;

@end

@implementation BiHuaBaoIndividualScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        CGPoint position = [UniversalUtil universaliPadPoint:CGPointMake(78, 216)
                                                 iPhonePoint:CGPointMake(39, 78)
                                                     offsetX:0
                                                     offsetY:0];
        self.originalLifeFrame = CGRectMake(position.x,
                                            position.y,
                                            [UniversalUtil universalDelta:38],
                                            [UniversalUtil universalDelta:431]);
    }
    
    return self;
}

- (void)didMoveToView:(nonnull SKView *)view {
    [super didMoveToView:view];
    
    self.uikitContainer.userInteractionEnabled = NO;
}

- (void)willMoveFromView:(nonnull SKView *)view {
    [self.lifeView removeFromSuperview];
    [self.lifeLab removeFromSuperview];
    [self.timeBtn removeFromSuperview];
    
    [super willMoveFromView:view];
}

- (void)buildLife {
    // Life
    SKSpriteNode *lifeBackground = [SKSpriteNode spriteNodeWithImageNamed:@"life_background"];
    lifeBackground.zPosition = zPostionFront;
    lifeBackground.position = [UniversalUtil universaliPadPoint:CGPointMake(98, 334)
                                                    iPhonePoint:CGPointMake(49, (self.size.height - self.uikitContainer.bounds.size.height) / 2 - 10)
                                                        offsetX:0
                                                        offsetY:0];
    [self addNode:lifeBackground atWorldLayer:HSSWorldLayerControl];
    
    self.lifeView = [[GradientView alloc] initWithFrame:self.originalLifeFrame
                                              fromColor:[UIColor orangeColor]
                                                toColor:[UIColor redColor]];
    self.lifeView.layer.cornerRadius = [UniversalUtil universalDelta:20];
    self.lifeView.layer.masksToBounds = YES;
    self.lifeView.backgroundColor = [UIColor clearColor];
    self.lifeView.center = CGPointMake(lifeBackground.position.x, self.size.height - lifeBackground.position.y);
    [self.view addSubview:self.lifeView];
    
    self.lifeLab = [[UILabel alloc] initWithFrame:CGRectMake(self.lifeView.frame.origin.x + self.lifeView.frame.size.width / 2 - [UniversalUtil universalDelta:25],
                                                             self.lifeView.frame.origin.y + self.lifeView
                                                             .frame.size.height - [UniversalUtil universalDelta:50] - [UniversalUtil universalDelta:20],
                                                             [UniversalUtil universalDelta:50],
                                                             [UniversalUtil universalDelta:50])];
    self.lifeLab.backgroundColor = [UIColor clearColor];
    self.lifeLab.textColor = [UIColor whiteColor];
    self.lifeLab.font = [UIFont fontWithName:FONT_NAME_HP size:[UniversalUtil universalFontSize:30]];
    self.lifeLab.text = [NSString stringWithFormat:@"%d", MAX_LIFE];
    self.lifeLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.lifeLab];
    
    // Clock
    self.timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.timeBtn.userInteractionEnabled = NO;
    self.timeBtn.frame = CGRectMake(self.lifeView.frame.origin.x + self.lifeView.frame.size.width / 2 - [UniversalUtil universalDelta:59],
                                    self.lifeView.frame.origin.y - [UniversalUtil universalDelta:59],
                                    [UniversalUtil universalDelta:118],
                                    [UniversalUtil universalDelta:118]);
    [self.timeBtn setBackgroundImage:[UIImage imageNamed:@"time_bg"]
                            forState:UIControlStateNormal];
    self.timeBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_HP size:[UniversalUtil universalFontSize:30]];
    self.timeBtn.titleLabel.numberOfLines = 0;
    self.timeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.timeBtn];
}

#pragma mark - Override
- (void)loadGameDataFrom:(NSInteger)fromPos count:(NSInteger)count Complete:(void (^)(void))complete failure:(void (^)(NSDictionary *))failure {
    if (![GlobalUtil isNetworkConnection]) {
        [self.myGameMgr loadLocalGameData];
        if (complete) {
            complete();
        }
        
        return;
    }
    
    if (fromPos <= 0) {
        [self.myGameMgr loadServerIndividualGameDataCompletion:^{
            if (complete) {
                complete();
            }
        } failure:^(NSDictionary *errorInfo) {
            if (failure) {
                failure(errorInfo);
            }
        }];
    }
    else {
        [self.myGameMgr loadServerIndividualMoreGameDataCompletion:^{
            if (complete) {
                complete();
            }
        } failure:^(NSDictionary *errorInfo) {
            if (failure) {
                failure(errorInfo);
            }
        }];
    }
}

- (void)addControllers {
    [super addControllers];
    
    for (HSButtonSprite *button in self.buttons) {
        button.position = CGPointMake(button.position.x, [UniversalUtil universalDelta:122]);
        if ([button.name isEqualToString:kLeftButton] ||
            [button.name isEqualToString:kRightButton]) {
            button.alpha = 0.0;
        }
        else if ([button.name isEqualToString:kBackButton]) {
            button.position = [UniversalUtil universaliPadPoint:CGPointMake(962, button.position.y)
                                                    iPhonePoint:CGPointMake(441, button.position.y)
                                                        offsetX:0
                                                        offsetY:0];
        }
    }
}

- (void)buildWorld {
    [super buildWorld];
    
    [self buildLife];
}

- (void)changeLifeWith:(NSInteger)life {
    CGFloat percent = (float)life / MAX_LIFE;
    if (percent > 1.0) {
        percent = 1.0;
    }
    
    CGFloat startY = self.originalLifeFrame.size.height * (1 - percent);
    [self.lifeView changeGradientFromPosition:CGPointMake(CGRectGetWidth(self.lifeView.bounds) / 2, startY)
                                  endPosition:CGPointMake(CGRectGetWidth(self.lifeView.bounds) / 2, self.lifeView.bounds.size.height)];
    
    self.lifeLab.text = [NSString stringWithFormat:@"%ld", (long)life];
}

- (void)finishAll {
    [super finishAll];
    
    [self.myGameMgr gameEnd];
    [self showMask:YES];
    [self showShare];
}

- (void)gameOver {
    [super gameOver];
    
    [self playGameOverSound];
    [self.myGameMgr gameEnd];
    [self showMask:YES];
    [self showShare];
}

- (void)refreshTime:(NSInteger)time {
    [self.timeBtn setTitle:[NSString stringWithFormat:@"%ld\n秒", (long)time]
                  forState:UIControlStateNormal];
}

- (void)wrong {
    [AccountMgr sharedInstance].user.score--;
    
    if ([AccountMgr sharedInstance].user.score == 0) {
        [self gameOver];
    }
    else {
        self.curIndex++;
    }
}

#pragma mark - AlertView
- (void)alertViewCancel:(UIAlertView *)alertView {
    
}

@end
