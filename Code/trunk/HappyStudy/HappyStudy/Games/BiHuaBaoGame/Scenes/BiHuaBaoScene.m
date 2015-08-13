//
//  DaDiShuScene.m
//  EasyLSP
//
//  Created by Q on 15/4/7.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "BiHuaBaoScene.h"
#import "GameSelectScene.h"
#import "GameSelectIndividualScene.h"
#import "Cannon.h"
#import "CrabCard.h"
#import "Pirate.h"
#import "EnvironmentCrab.h"
#import "BHBMgr.h"
#import "AccountMgr.h"
#import "GameMgr.h"
#import "BHBModel.h"
#import "SKScene+EzLearn.h"

typedef enum {
    RotateStatStop = 0,
    RotateStatLeft,
    RotateStatRight,
}RotateStat;

@interface BiHuaBaoScene()<SKPhysicsContactDelegate>

@property (strong, nonatomic) Cannon *cannon;

@property (strong, nonatomic) NSMutableArray *evironmentElements;
@property (strong, nonatomic) NSArray *cardPositions;

@property (nonatomic) RotateStat rotateStat;
@property (nonatomic) CGPoint lastPosition;
@property (nonatomic) BOOL isCannonRotating;

@end

@implementation BiHuaBaoScene
@synthesize curIndex = _curIndex;

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.cardPositions = @[[NSValue valueWithCGPoint:CGPointMake(200, 300)],
                               [NSValue valueWithCGPoint:CGPointMake(400, 500)],
                               [NSValue valueWithCGPoint:CGPointMake(700, 400)],
                               [NSValue valueWithCGPoint:CGPointMake(900, 450)]];
        self.isCannonRotating = NO;
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

- (void)buildWorld {
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsWorld.contactDelegate = self;
    
    // Evironment
    SKSpriteNode *backgroundSp = [SKSpriteNode spriteNodeWithImageNamed:@"bihuabao_background"];
    backgroundSp.anchorPoint = CGPointZero;
    backgroundSp.position = CGPointZero;
    backgroundSp.zPosition = zPostionBackground;
    backgroundSp.size = self.size;
    [self addNode:backgroundSp atWorldLayer:HSSWorldLayerGround];
    
    Pirate *pirate = [[Pirate alloc] initWithTexture:nil];
    pirate.anchorPoint = CGPointMake(1, 0);
    pirate.requestedAnimation = HSAnimationStateIdle;
    pirate.position = CGPointMake(self.size.width, 0);
    [self addNode:pirate atWorldLayer:HSSWorldLayerGround];
    [self.evironmentElements addObject:pirate];
    
    EnvironmentCrab *eCrab = [[EnvironmentCrab alloc] initWithTexture:nil];
    eCrab.requestedAnimation = HSAnimationStateIdle;
    eCrab.anchorPoint = CGPointMake(0, 1);
    eCrab.position = [UniversalUtil universaliPadPoint:CGPointMake(95, 91.5)
                                           iPhonePoint:CGPOINT_NON
                                               offsetX:0
                                               offsetY:0];
    [self addNode:eCrab atWorldLayer:HSSWorldLayerGround];
    [self.evironmentElements addObject:eCrab];
    
    // Characters
    self.cannon = [[Cannon alloc] initWithTexture:[SKTexture textureWithImageNamed:@"canon"]
                                            title:@""];
    self.cannon.anchorPoint = CGPointMake(0.5, 0);
    self.cannon.position = CGPointMake(self.size.width / 2, 0);
    self.cannon.zPosition = zPostionCharacter;
    self.cannon.name = kCannon;
    [self addNode:self.cannon atWorldLayer:HSSWorldLayerCharacter];
    
    self.questionSprite = [[HSLabelSprite alloc] initWithTexture:[SKTexture textureWithImageNamed:@"fort"]
                                                           title:@""];
    self.questionSprite.anchorPoint = CGPointMake(0.5, 0);
    self.questionSprite.position = self.cannon.position;
    self.questionSprite.zPosition = zPostionCharacter;
    self.questionSprite.label.fontColor = [UIColor whiteColor];
    self.questionSprite.label.fontName = FONT_NAME_HP;
    self.questionSprite.label.fontSize = [UniversalUtil universalFontSize:40];
    self.questionSprite.label.position = CGPointMake(self.questionSprite.label.position.x,
                                                     [UniversalUtil universalDelta:10]);
    [self addNode: self.questionSprite atWorldLayer:HSSWorldLayerCharacter];
    
    // 滑动炮筒操作，隐藏操作剪头
    HSButtonSprite *rotateLeftNode = [[HSButtonSprite alloc] initWithTitle:nil
                                                                  norImage:@"rotate_left_btn"
                                                                  selImage:@"rotate_left_btn"];
    rotateLeftNode.anchorPoint = CGPointMake(0, 1);
    rotateLeftNode.position = CGPointMake(self.questionSprite.position.x - self.questionSprite.size.width / 2,
                                          self.questionSprite.position.y + self.questionSprite.size.height + rotateLeftNode.size.height * 1.5);
    rotateLeftNode.name = kRotateLeftButton;
    rotateLeftNode.zPosition = zPostionBackground;
    [self addNode:rotateLeftNode atWorldLayer:HSSWorldLayerControl];
    [self.buttons addObject:rotateLeftNode];
    
    HSButtonSprite *rotateRightNode = [[HSButtonSprite alloc] initWithTitle:nil
                                                                   norImage:@"rotate_right_btn"
                                                                   selImage:@"rotate_right_btn"];
    rotateRightNode.anchorPoint = CGPointMake(0, 1);
    rotateRightNode.position = CGPointMake(self.questionSprite.position.x + self.questionSprite.size.width / 2 - rotateRightNode.size.width,
                                           self.questionSprite.position.y + self.questionSprite.size.height + rotateLeftNode.size.height * 1.5);
    rotateRightNode.name = kRotateRightButton;
    rotateRightNode.zPosition = zPostionBackground;
    [self addNode:rotateRightNode atWorldLayer:HSSWorldLayerControl];
    [self.buttons addObject:rotateRightNode];
    
    // Cards
    for (int i = 0; i < 4; i++) {
        CrabCard *card = [[CrabCard alloc] initWithTexture:nil];
        card.zPosition = zPostionCharacter;
        card.position = [UniversalUtil universaliPadPoint:[self originalPositionWithIndex:i]
                                              iPhonePoint:CGPOINT_NON
                                                  offsetX:0
                                                  offsetY:0];
        card.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(card.size.width - [UniversalUtil universalDelta:20], card.size.height - [UniversalUtil universalDelta:20])];
        card.physicsBody.categoryBitMask = BHBColliderTypeCard;
        card.physicsBody.collisionBitMask = 0;
        card.physicsBody.contactTestBitMask = BHBColliderTypeProjectile;
        card.label.fontColor = colorRGB(72, 43, 43, 1);
        card.label.fontSize = [UniversalUtil universalFontSize:70.];
        card.label.fontName = FONT_NAME_CUTOON;
        card.label.position = CGPointMake(card.label.position.x, [UniversalUtil universalDelta:15]);
        card.requestedAnimation = HSAnimationStateIdle;
        [self addNode:card atWorldLayer:HSSWorldLayerCharacter];
        [self.cards addObject:card];
    }
}

- (void)changeLifeWith:(NSInteger)life {}

- (void)gameBegain {
    [self.myGameMgr gameStart];
    self.curIndex = 0;
    [self addCharacters:0];
}

- (void)loadGameMgr {
    self.myGameMgr = [[BHBMgr alloc] init];
    self.myGameMgr.gameScene = self;
}

- (CGPoint)originalPositionWithIndex:(NSInteger)index {
    NSValue *value = self.cardPositions[index];
    
    return CGPointMake(index > 2 ? self.size.width + [UniversalUtil universalDelta:100] : [UniversalUtil universalDelta:-100], [UniversalUtil universalDelta:[value CGPointValue].y]);
}

- (void)speakWithOptionIndex:(NSInteger)index {
    BHBModel *model = self.myGameMgr.models[self.curIndex];
    BHBOption *option = model.options[index];
#ifdef EZLEARN_DEBUG
#else
    [self playSound:option.sound completion:^{
        
    }];
#endif
}

- (void)refreshTime:(NSInteger)time {}

- (void)rotateCannon:(RotateStat)rotateStat {
    if (rotateStat == RotateStatLeft) {
        [self.cannon rotateLeft];
    }
    else if (rotateStat == RotateStatRight) {
        [self.cannon rotateRight];
    }
}

- (RotateStat)rotateStatWithPosition:(CGPoint)position {
    CGRect leftRect = CGRectMake(self.questionSprite.position.x - self.questionSprite.size.width / 2 - [UniversalUtil universalDelta:20],
                                 self.questionSprite.position.y + self.questionSprite.size.height,
                                 self.questionSprite.size.width / 2 + [UniversalUtil universalDelta:20],
                                 [UniversalUtil universalDelta:100]);
    CGRect rightRect = CGRectMake(self.questionSprite.position.x,
                                  self.questionSprite.position.y + self.questionSprite.size.height,
                                  self.questionSprite.size.width / 2 + [UniversalUtil universalDelta:20],
                                  [UniversalUtil universalDelta:100]);
    
    if (CGRectContainsPoint(leftRect, position)) {
        return RotateStatLeft;
    }
    
    if (CGRectContainsPoint(rightRect, position)) {
        return RotateStatRight;
    }
    
    return RotateStatStop;
}

#pragma mark - Override
+ (void)loadSceneAssets {
    [CrabCard loadAssets];
    [Pirate loadAssets];
    [EnvironmentCrab loadAssets];
}

+ (void)releaseSceneAssets {}

- (void)addCharacters:(NSInteger)index {
    [super addCharacters:index];
    
    if (self.gameMgr.models.count == 0 ||
        index >= self.gameMgr.models.count) {
        return;
    }
    
    BHBModel *model = self.myGameMgr.models[index];
    BHBQuestion *question = model.question;
    self.questionSprite.label.text = [NSString stringWithFormat:@"%@画", question.title];
    
    for (int i = 0; i < self.cards.count; i++) {
        BHBOption *option = model.options[i];
        CrabCard *card = self.cards[i];
        card.requestedAnimation = HSAnimationStateIdle;
        card.isAnswer = option.isAnswer;
        
        NSValue *value = self.cardPositions[i];
        
        SKAction *positionAction = [SKAction moveTo:[self originalPositionWithIndex:i] duration:0];
        SKAction *changeAction = [SKAction runBlock:^{
            card.label.text = option.title;
        }];
        SKAction *moveAction = [SKAction moveTo:[UniversalUtil universaliPadPoint:value.CGPointValue
                                                                      iPhonePoint:CGPOINT_NON
                                                                          offsetX:0
                                                                          offsetY:-30]
                                       duration:0.5];
        SKAction *doneAction = [SKAction runBlock:^{
            
        }];
        [card runAction:[SKAction sequence:@[positionAction, changeAction, moveAction, doneAction]]];
    }
}

- (void)destroyCharacters {}

- (NSString *)indexStringWith:(NSInteger)index {
    BHBModel *model = self.myGameMgr.models[index];
    
    return model.indexStr;
}

- (NSInteger)currentTotalCount {
    return self.myGameMgr.models.count;
}

- (void)finishAll {
    [super finishAll];
    
    [self addCharacters:self.curIndex];
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
    if (index > self.myGameMgr.models.count - 1) {
        if (self.myGameMgr.curGroupCount > 0) {
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
            index = self.myGameMgr.models.count - 1;
        }
    }
    
    self.curIndex = index;
}

- (void)clickBack:(id)sender {
    [self.myGameMgr clean];
    [self.myGameMgr.models removeAllObjects];
    if ([GameMgr sharedInstance].gameGroup == GroupIndividual) {
        GameSelectIndividualScene *scene = [[GameSelectIndividualScene alloc] initWithSize:self.size];
        [self.view presentScene:scene];
    }
    else if ([GameMgr sharedInstance].gameGroup == GroupSchool) {
        GameSelectScene *scene = [[GameSelectScene alloc] initWithSize:self.size];
        [self.view presentScene:scene];
    }
}

#pragma mark - SKPhysicsBody
- (void)didBeginContact:(SKPhysicsContact *)contact {
    if (self.myGameMgr.stat == BHBGameStatEnd) {
        return;
    }
    
    if (contact.bodyA.categoryBitMask & BHBColliderTypeProjectile ||
        contact.bodyB.categoryBitMask & BHBColliderTypeProjectile) {
        
        [self playSound:@"bhb_shoot_target.mp3" completion:nil];
        
        SKNode *projectile = contact.bodyA.categoryBitMask & BHBColliderTypeProjectile ? contact.bodyA.node : contact.bodyB.node;
        [projectile removeFromParent];
        
        CrabCard *card = (CrabCard *)([projectile isEqual:contact.bodyA.node] ? contact.bodyB.node : contact.bodyA.node);
        NSInteger index = [self.cards indexOfObject:card];
        
        if (card.isAnswer) {
            [self speakWithOptionIndex:index];
            [self playCorrectFemaleSound];
            [self showCorrectCongratulations:CGPointMake(card.position.x, card.position.y + card.size.height / 2)
                                  completion:^{
                                      [self.myGameMgr correct];
                                  }];
        }
        else {
            [self playWrongSound];
            SKAction *zoomOut = [SKAction scaleTo:1.5 duration:0.3];
            SKAction *zoomIn = [SKAction scaleTo:1.0 duration:0.3];
            [card runAction:[SKAction sequence:@[zoomOut, zoomIn]]
                 completion:^{
                     [self.myGameMgr wrong];
                 }];
        }
        
        card.requestedAnimation = HSAnimationStateDeath;
    }
}

#pragma mark - Loop
- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)interval {
    for (HSCharacter *environmentElement in self.evironmentElements) {
        [environmentElement updateWithTimeSinceLastUpdate:interval];
    }
    
    for (CrabCard *card in self.cards) {
        [card updateWithTimeSinceLastUpdate:interval];
    }
    
    [self.myGameMgr gameLogic:interval];
    [self rotateCannon:self.rotateStat];
    
    if (self.cannon.wantFire) {
//        [self.cannon faceToLocation:self.cannon.targetLocation];
        [self.cannon fire];
    }
}

#pragma mark - Touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint loc = [touch locationInNode:self];
    
    SKNode *node = [self nodeAtPoint:loc];
    NSString *buttonName = node.name;
    // 操作箭头
//    self.rotateStat = [self rotateStatWithPosition:loc];
//    
//    if (buttonName) {
//        [self setButtonSelectState:buttonName];
//    }
//    else if (self.rotateStat == RotateStatStop) {
//        self.cannon.targetLocation = loc;
//        self.cannon.wantFire = YES;
//    }
    
    if (buttonName) {
        if ([buttonName isEqualToString:kCannon]) {
            self.isCannonRotating = YES;
            self.lastPosition = loc;
        }
        
        [self setButtonSelectState:buttonName];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint loc = [touch locationInNode:self];
    
    // 操作箭头
//    self.rotateStat = [self rotateStatWithPosition:loc];
    
    if (self.isCannonRotating) {
        [self.cannon faceToLocation:loc];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint loc = [touch locationInNode:self];
    
    if (self.isCannonRotating) {
        self.isCannonRotating = NO;
        self.cannon.targetLocation = loc;
        self.cannon.wantFire = YES;
        
        return;
    }
    
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
    else {
        
    }
    
    self.rotateStat = RotateStatStop;
    [self setButtonSelectState:nil];
    
    [super touchesEnded:touches withEvent:event];
}

#pragma mark - Property
- (NSMutableArray *)cards {
    if (!_cards) {
        _cards = [NSMutableArray arrayWithCapacity:4];
    }
    
    return _cards;
}

- (NSMutableArray *)evironmentElements {
    if (!_evironmentElements) {
        _evironmentElements = [NSMutableArray array];
    }
    
    return _evironmentElements;
}

- (NSArray *)cardPositions {
    if (!_cardPositions) {
        _cardPositions = [NSArray array];
    }
    
    return _cardPositions;
}

- (void)setMyGameMgr:(BHBMgr *)myGameMgr {
    _myGameMgr = myGameMgr;
    self.gameMgr = myGameMgr;
}

@end
