//
//  DaDiShuIndividualScene.m
//  EasyLSP
//
//  Created by Quan on 15/5/8.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "DaDiShuIndividualScene.h"
#import "DDSIndividualMgr.h"
#import "AccountMgr.h"

#import "GradientView.h"

@interface DaDiShuIndividualScene()<UIAlertViewDelegate>

@property (strong, nonatomic) GradientView *lifeView;
@property (strong, nonatomic) UILabel *lifeLab;

@property (nonatomic) CGRect originalLifeFrame;

@end

@implementation DaDiShuIndividualScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.holePostions = @[[NSValue valueWithCGRect:CGRectMake(240, 300, -M_PI / 12, 1)],
                              [NSValue valueWithCGRect:CGRectMake(396, 170, 0, 0)],
                              [NSValue valueWithCGRect:CGRectMake(460, 330, 0, 0)],
                              [NSValue valueWithCGRect:CGRectMake(340, 435, 0, 0)],
                              [NSValue valueWithCGRect:CGRectMake(596, 230, M_PI / 12, 1)],
                              [NSValue valueWithCGRect:CGRectMake(670, 422, 0, 0)],
                              [NSValue valueWithCGRect:CGRectMake(900, 240, -M_PI / 12, 0)],
                              [NSValue valueWithCGRect:CGRectMake(920, 410, 0, 1)],
                              [NSValue valueWithCGRect:CGRectMake(835, 500, 0, 0)]];
        self.gopherPositions = @[[NSValue valueWithCGRect:CGRectMake(240, 300, -M_PI / 12, 1)],
                                 [NSValue valueWithCGRect:CGRectMake(380, 170, 0, 0)],
                                 [NSValue valueWithCGRect:CGRectMake(440, 330, 0, 0)],
                                 [NSValue valueWithCGRect:CGRectMake(320, 435, 0, 0)],
                                 [NSValue valueWithCGRect:CGRectMake(626, 230, M_PI / 12, 1)],
                                 [NSValue valueWithCGRect:CGRectMake(650, 422, 0, 0)],
                                 [NSValue valueWithCGRect:CGRectMake(875, 240, -M_PI / 12, 0)],
                                 [NSValue valueWithCGRect:CGRectMake(935, 410, 0, 1)],
                                 [NSValue valueWithCGRect:CGRectMake(820, 500, 0, 0)]];
        
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

- (void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    
    self.uikitContainer.userInteractionEnabled = NO;
}

- (void)willMoveFromView:(nonnull SKView *)view {
    [self.lifeView removeFromSuperview];
    [self.lifeLab removeFromSuperview];
    
    [super willMoveFromView:view];
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

#pragma mark - Override
- (void)addControllers {
    [super addControllers];
    
    for (HSButtonSprite *button in self.buttons) {
        button.position = CGPointMake(button.position.x, [UniversalUtil universalDelta:122]);
        if ([button.name isEqualToString:kLeftButton] ||
            [button.name isEqualToString:kRightButton]) {
            button.alpha = 0.0;
        }
        else if ([button.name isEqualToString:kBackButton]) {
            button.position = [UniversalUtil universaliPadPoint:CGPointMake(98, 122)
                                                    iPhonePoint:CGPointMake(49, 61)
                                                        offsetX:0
                                                        offsetY:0];
        }
    }
    
    [self showAD];
}

- (void)buildWorld {
    [super buildWorld];
    
    [self buildLife];
}

- (void)buildLife {
    // Life
    SKSpriteNode *lifeBackground = [SKSpriteNode spriteNodeWithImageNamed:@"life_background"];
    lifeBackground.zPosition = zPostionFront;
    lifeBackground.position = [UniversalUtil universaliPadPoint:CGPointMake(98, 334)
                                                    iPhonePoint:CGPointMake(49, self.size.height / 2 - 10)
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
}

- (void)finishAll {
    [super finishAll];
    
    [self showMask:YES];
    [self showShare];
}

- (void)gameOver {
    [super gameOver];
    
    [self playGameOverSound];
    [self showMask:YES];
    [self showShare];
}

- (void)loadGameMgr {
    self.myGameMgr = [[DDSIndividualMgr alloc] init];
    self.myGameMgr.gameScene = self;
}

- (void)loadGameDataFrom:(NSInteger)fromPos count:(NSInteger)count Complete:(void (^)(void))complete failure:(void (^)(NSDictionary *))failure {
    [self.myGameMgr loadLocalGameData];
    if (complete) {
        complete();
    }
}

#pragma mark - AlertView
- (void)alertViewCancel:(UIAlertView *)alertView {
    [self clickBack:nil];
}

@end
