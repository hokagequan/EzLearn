//
//  DaDiShuScene.m
//  EasyLSP
//
//  Created by Q on 15/4/7.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "ZiMuKuangScene.h"
#import "GameSelectScene.h"
#import "GameSelectIndividualScene.h"
#import "ZMKMgr.h"
#import "AccountMgr.h"
#import "GameMgr.h"
#import "ZMKModel.h"

#import "GradientView.h"

#define BASKET_NAME @"basket"

#define SCORE_MAX 5

@interface ZiMuKuangScene()<SKPhysicsContactDelegate>

@property (strong, nonatomic) GradientView *lifeView;
@property (strong, nonatomic) UILabel *lifeLab;

@property (nonatomic) CGRect originalLifeFrame;
@property (nonatomic) BOOL isDraggingBasket;

@end

@implementation ZiMuKuangScene
@synthesize curIndex = _curIndex;

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.droppingDuration = 3.4;
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
    
    self.pageCount = self.myGameMgr.models.count;
    
    [self addControllers];
    [self buildWorld];
    [self gameBegain];
}

- (void)willMoveFromView:(SKView *)view {
    [self.lifeView removeFromSuperview];
    [self.lifeLab removeFromSuperview];
    
    [super willMoveFromView:view];
}

- (void)addControllers {
    HSButtonSprite *leftNode = [[HSButtonSprite alloc] initWithTitle:nil
                                                            norImage:@"pre_page_nor"
                                                            selImage:@"pre_page_sel"];
    leftNode.position = [UniversalUtil universaliPadPoint:CGPointMake(832, 102)
                                              iPhonePoint:CGPOINT_NON
                                                  offsetX:-30
                                                  offsetY:0];
    leftNode.name = kLeftButton;
    leftNode.zPosition = zPostionFront;
    [self addNode:leftNode atWorldLayer:HSSWorldLayerControl];
    [self.buttons addObject:leftNode];
    
    HSButtonSprite *rightNode = [[HSButtonSprite alloc] initWithTitle:nil
                                                             norImage:@"next_page_nor"
                                                             selImage:@"next_page_sel"];
    rightNode.position = [UniversalUtil universaliPadPoint:CGPointMake(962, 102)
                                               iPhonePoint:CGPOINT_NON
                                                   offsetX:-30
                                                   offsetY:0];
    rightNode.name = kRightButton;
    rightNode.zPosition = zPostionFront;
    [self addNode:rightNode atWorldLayer:HSSWorldLayerControl];
    [self.buttons addObject:rightNode];
    
    HSButtonSprite *backNode = [[HSButtonSprite alloc] initWithTitle:nil
                                                            norImage:@"back_nor"
                                                            selImage:@"back_sel"];
    backNode.position = [UniversalUtil universaliPadPoint:CGPointMake(705, 102)
                                              iPhonePoint:CGPointMake(332, 51)
                                                  offsetX:-30
                                                  offsetY:0];
    backNode.name = kBackButton;
    backNode.zPosition = zPostionFront;
    [self addNode:backNode atWorldLayer:HSSWorldLayerControl];
    [self.buttons addObject:backNode];
}

- (void)addFruitToBasket:(HSLabelSprite *)fruit {
    HSLabelSprite *toAddFruit = [[HSLabelSprite alloc] initWithTexture:fruit.texture
                                                                 title:fruit.label.text];
    toAddFruit.label.position = fruit.label.position;
    toAddFruit.label.fontColor = fruit.label.fontColor;
    toAddFruit.label.fontSize = fruit.label.fontSize;
    toAddFruit.label.fontName = fruit.label.fontName;
    [self.basket addFruit:toAddFruit];
}

- (void)buildWorld {
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsWorld.contactDelegate = self;
    
    SKSpriteNode *backgroundSp = [SKSpriteNode spriteNodeWithImageNamed:@"zimukuang_game_background"];
    backgroundSp.anchorPoint = CGPointZero;
    backgroundSp.position = CGPointZero;
    backgroundSp.zPosition = zPostionBackground;
    backgroundSp.size = self.size;
    [self addNode:backgroundSp atWorldLayer:HSSWorldLayerGround];
    
    // Characters
    self.basket = [[ZMKBasket alloc] initWithTexture:[SKTexture textureWithImageNamed:@"basket"]
                                               title:@""];
    self.basket.name = BASKET_NAME;
    self.basket.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.basket.size.width / 2, self.basket.size.height / 2)];
    self.basket.physicsBody.categoryBitMask = ZMKColliderTypeBasket;
    self.basket.physicsBody.collisionBitMask = 0;
    self.basket.physicsBody.contactTestBitMask = ZMKColliderTypeFruit;
    self.basket.position = [UniversalUtil universalPointFromCenter:[GlobalUtil centerInSize:self.size]
                                                            deltaX:0
                                                            deltaY:-184
                                                           offsetX:0
                                                           offsetY:0];
    self.basket.zPosition = zPostionCharacter;
    self.basket.label.position = CGPointMake(self.basket.label.position.x, self.basket.label.position.y - [UniversalUtil universalDelta:20]);
    self.basket.label.fontName = FONT_NAME_HP;
    self.basket.label.fontSize = [UniversalUtil universalDelta:40.];
    [self addNode:self.basket atWorldLayer:HSSWorldLayerCharacter];
    
    // Fruit
    self.fruit = [[HSLabelSprite alloc] initWithTexture:[SKTexture textureWithImageNamed:@"zimukuang_fruit1"]
                                                  title:@""];
    self.fruit.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.fruit.size];
    self.fruit.physicsBody.categoryBitMask = ZMKColliderTypeFruit;
    self.fruit.physicsBody.collisionBitMask = 0;
    self.fruit.physicsBody.contactTestBitMask = ZMKColliderTypeBasket;
    self.fruit.zPosition = zPostionCharacter;
    self.fruit.position = CGPointMake(self.size.width / 2, self.size.height + 100);
    self.fruit.label.position = CGPointMake(0, 0);
    self.fruit.label.fontName = FONT_NAME_HP;
    self.fruit.label.fontSize = [UniversalUtil universalDelta:40.];
    [self addNode:self.fruit atWorldLayer:HSSWorldLayerCharacter];
    
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

- (void)centerFruitLabelWithIndex:(NSInteger)index {
    CGPoint position = CGPointZero;
    switch (index) {
        case 1:
        case 4:
            position.y = [UniversalUtil universalDelta:-30];
            break;
        case 2:
            position = [UniversalUtil universaliPadPoint:CGPointMake(-14, -16)
                                             iPhonePoint:CGPOINT_NON
                                                 offsetX:0
                                                 offsetY:0];
            break;
        case 3:
            position.y = [UniversalUtil universalDelta:-8];
            break;
            
        default:
            break;
    }
    
    self.fruit.label.position = position;
}

- (void)cleanBasketFruits {
    [self.basket clean];
}

- (void)dropFruitFrom:(CGPoint)position text:(NSString *)text duration:(CGFloat)duration {
    if ([self.fruit actionForKey:DROPPING_ANIMATION]) {
        [self.fruit removeActionForKey:DROPPING_ANIMATION];
    }
    
    SKAction *changeFruitAction = [SKAction runBlock:^{
        NSUInteger random = [GlobalUtil randomIntegerWithMax:4] + 1;
        SKTexture *texture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"zimukuang_fruit%ld", (long)random]];
        self.fruit.texture = texture;
        self.fruit.size = texture.size;
        self.fruit.label.text = text;
        [self centerFruitLabelWithIndex:random];
    }];
    
    self.droppingDuration = duration;
    
    SKAction *positionAction = [SKAction moveTo:position duration:0];
    SKAction *moveAction = [SKAction moveToY:-100 duration:self.droppingDuration];
    
    [self.fruit runAction:[SKAction sequence:@[positionAction, changeFruitAction, moveAction]]
                  withKey:DROPPING_ANIMATION];
}

- (void)gameBegain {
    [self.myGameMgr gameStart];
    [self addCharacters:0];
}

- (void)loadGameMgr {
    self.myGameMgr = [[ZMKMgr alloc] init];
    self.myGameMgr.gameScene = self;
}

- (void)removeFruitFromBasket {
    [self.basket removeSingleFruit];
}

- (void)resetFruit {
    self.fruit.position = CGPointMake(self.fruit.position.x, self.size.height + 100);
}

#pragma mark - Override
+ (void)loadSceneAssets {}

+ (void)releaseSceneAssets {}

- (void)addCharacters:(NSInteger)index {
    if ([self.fruit actionForKey:DROPPING_ANIMATION]) {
        [self.fruit removeActionForKey:DROPPING_ANIMATION];
    }
    
    if (index >= self.myGameMgr.models.count) {
        return;
    }
    
    ZMKModel *model = self.myGameMgr.models[index];
    [model reloadOptions];
    
    self.basket.label.text = model.question.title;
    
#ifdef EZLEARN_DEBUG
#else
    [self playSound:model.question.sound completion:^{
        
    }];
#endif
    
    [self dropFruitFrom:[self.myGameMgr randomPosition]
                   text:[self.myGameMgr characterInFruit]
               duration:self.droppingDuration];
}

- (void)destroyCharacters {}

- (NSString *)indexStringWith:(NSInteger)index {
    ZMKModel *model = self.gameMgr.models[index];
    
    return model.question.title;
}

- (NSInteger)currentTotalCount {
    return self.gameMgr.models.count;
}

- (BOOL)isFruitDropping {
    return [self.fruit actionForKey:DROPPING_ANIMATION] != nil;
}

- (void)loadGameDataFrom:(NSInteger)fromPos count:(NSInteger)count Complete:(void (^)(void))complete failure:(void (^)(NSDictionary *))failure {
    [self.myGameMgr loadServerGameDataCompletion:complete
                                         failure:failure];
}

- (void)loadMore {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [self.myGameMgr loadServerMoreGameDataCompletion:^{
        [SVProgressHUD dismiss];
        [self expandIndexController];
    } failure:^(NSDictionary *errorInfo) {
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - Actions
- (void)clickLeft:(id)sender {
    NSInteger index = self.curIndex;
    index--;
    if (index < 0) {
        index = 0;
    }
    
    self.curIndex = index;
}

- (void)clickRight:(id)sender {
    NSInteger index = self.curIndex;
    index++;
    if (index > self.gameMgr.models.count - 1) {
        if (self.gameMgr.curGroupCount > 0) {
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
            [self.myGameMgr loadServerMoreGameDataCompletion:^{
                [SVProgressHUD dismiss];
                [self expandIndexController];
                self.curIndex = index;
            } failure:^(NSDictionary *errorInfo) {
                [SVProgressHUD dismiss];
            }];
            
            return;
        }
        else {
            index = self.gameMgr.models.count - 1;
        }
    }
    
    self.curIndex = index;
}

- (void)clickBack:(id)sender {
    [self.gameMgr.models removeAllObjects];
    
    if ([GameMgr sharedInstance].gameGroup == GroupIndividual) {
        GameSelectIndividualScene *scene = [[GameSelectIndividualScene alloc] initWithSize:self.size];
        [self.view presentScene:scene];
    }
    else if ([GameMgr sharedInstance].gameGroup == GroupSchool) {
        GameSelectScene *scene = [[GameSelectScene alloc] initWithSize:self.size];
        [self.view presentScene:scene];
    }
}

#pragma mark - SKPhysicsContact
- (void)didBeginContact:(SKPhysicsContact *)contact {
    SKNode *nodeA = contact.bodyA.node;
    SKNode *nodeB = contact.bodyB.node;
    if ([nodeA isKindOfClass:[HSLabelSprite class]] &&
        [nodeB isKindOfClass:[HSLabelSprite class]]) {
        if ([self.fruit actionForKey:DROPPING_ANIMATION]) {
            [self.fruit removeActionForKey:DROPPING_ANIMATION];
        }
        [self.myGameMgr checkNode:(HSLabelSprite *)nodeA with:(HSLabelSprite *)nodeB];
    }
}

#pragma mark - Loop
- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)interval {
    [self.myGameMgr gameLogic:interval];
}

#pragma mark - Touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint loc = [touch locationInNode:self];
    
    SKNode *node = [self nodeAtPoint:loc];
    NSString *nodeName = node.name;
    if ([nodeName isEqualToString:BASKET_NAME]) {
        self.isDraggingBasket = YES;
    }
    else {
        [self setButtonSelectState:nodeName];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.isDraggingBasket) {
        UITouch *touch = [touches anyObject];
        CGPoint loc = [touch locationInNode:self];
        self.basket.position = CGPointMake(loc.x, self.basket.position.y);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint loc = [touch locationInNode:self];
    
    if (!self.isDraggingBasket) {
        SKNode *node = [self nodeAtPoint:loc];
        if ([node.name isEqualToString:kLeftButton]) {
            [self clickLeft:node];
        }
        else if ([node.name isEqualToString:kRightButton]) {
            [self clickRight:node];
        }
        else if ([node.name isEqualToString:kBackButton]) {
            [self clickBack:node];
        }
        
        [self setButtonSelectState:nil];
    }
    
    self.isDraggingBasket = NO;
    
    [super touchesEnded:touches withEvent:event];
}

#pragma mark - Property
- (NSMutableArray *)characters {
    if (!_characters) {
        _characters = [NSMutableArray arrayWithCapacity:4];
    }
    
    return _characters;
}

- (NSMutableArray *)cards {
    if (!_cards) {
        _cards = [NSMutableArray arrayWithCapacity:4];
    }
    
    return _cards;
}

- (void)setMyGameMgr:(ZMKMgr *)myGameMgr {
    _myGameMgr = myGameMgr;
    self.gameMgr = myGameMgr;
}

@end
