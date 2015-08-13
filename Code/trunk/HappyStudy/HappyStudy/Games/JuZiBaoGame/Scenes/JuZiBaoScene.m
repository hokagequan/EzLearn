//
//  DaDiShuScene.m
//  EasyLSP
//
//  Created by Q on 15/4/7.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "JuZiBaoScene.h"
#import "GameSelectScene.h"
#import "JZBFrog.h"
#import "OptionLeaf.h"
#import "StepCell.h"
#import "JZBMgr.h"
#import "AccountMgr.h"
#import "JZBModel.h"

#import "GradientView.h"

#define FALL_DOWN_STANDARD_TIME 3
#define MOVE_LEFT -1
#define MOVE_RIGHT 1
#define WORLD_MOVE_SPEED 180

@interface JuZiBaoScene()<SKPhysicsContactDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) SKNode *riverLayer1;
@property (strong, nonatomic) SKNode *riverLayer2;
@property (strong, nonatomic) GradientView *lifeView;
@property (strong, nonatomic) JZBFrog *frog;
@property (strong, nonatomic) SKSpriteNode *emptyLeaf;
@property (strong, nonatomic) SKSpriteNode *emptyLeaf2;
@property (strong, nonatomic) OptionLeaf *draggingLeaf;
@property (strong, nonatomic) OptionLeaf *fakeLeaf;

@property (strong, nonatomic) NSArray *leafPositions;
@property (nonatomic) CGPoint fitLocation;
@property (nonatomic) CGPoint river1StartMovingPosition;
@property (nonatomic) CGPoint river2StartMovingPosition;
@property (nonatomic) NSInteger lastIndex;
@property (nonatomic) NSInteger curRiverLayerIndex;
@property (nonatomic) NSInteger worldMoveDirection;
@property (nonatomic) BOOL isDraggingLeaf;
@property (nonatomic) BOOL isWorldMoving;

@end

@implementation JuZiBaoScene
@synthesize curIndex = _curIndex;

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.leafPositions = @[[NSValue valueWithCGPoint:CGPointMake(293, 393)],
                               [NSValue valueWithCGPoint:CGPointMake(490, 293)],
                               [NSValue valueWithCGPoint:CGPointMake(730, 234)],
                               [NSValue valueWithCGPoint:CGPointMake(908, 393)]];
        self.curRiverLayerIndex = 0;
        self.lastIndex = 0;
        self.isWorldMoving = NO;
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

- (CGPoint)adjustFrogPositionWith:(CGPoint)position {
    return CGPointMake(position.x, position.y + self.frog.size.height / 2 + 20);
}

- (void)buildWorld {
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsWorld.contactDelegate = self;
    
    self.riverLayer1 = [SKNode node];
    self.riverLayer1.position = CGPointZero;
    self.river1StartMovingPosition = self.riverLayer1.position;
    [self addNode:self.riverLayer1 atWorldLayer:HSSWorldLayerGround];
    
    self.riverLayer2 = [SKNode node];
    self.riverLayer2.position = CGPointMake(self.riverLayer1.position.x + self.size.width, self.riverLayer1.position.y);
    self.river2StartMovingPosition = self.riverLayer2.position;
    [self addNode:self.riverLayer2 atWorldLayer:HSSWorldLayerGround];
    
    SKSpriteNode *backgroundSp = [SKSpriteNode spriteNodeWithImageNamed:@"juzibao_background"];
    backgroundSp.anchorPoint = CGPointZero;
    backgroundSp.position = CGPointZero;
    backgroundSp.zPosition = zPostionBackground;
    backgroundSp.size = self.size;
    [self.riverLayer1 addChild:backgroundSp];
    
    SKSpriteNode *backgroundSpCopy = [backgroundSp copy];
    [self.riverLayer2 addChild:backgroundSpCopy];
    
    self.optionBackground = [SKSpriteNode spriteNodeWithImageNamed:@"juzibao_option_bg"];
    self.optionBackground.anchorPoint = CGPointMake(0, 1);
    self.optionBackground.zPosition = zPostionBackground;
    self.optionBackground.position = [UniversalUtil universaliPadPoint:CGPointMake(50, self.size.height / 2 + self.optionBackground.size.height / 2)
                                                           iPhonePoint:CGPointMake(25, (self.size.height - self.uikitContainer.bounds.size.height) / 2 + self.optionBackground.size.height / 2)
                                                               offsetX:0
                                                               offsetY:0];
    [self addNode:self.optionBackground atWorldLayer:HSSWorldLayerControl];
    
    // Characters
    self.frog = [[JZBFrog alloc] initWithTexture:nil];
    NSValue *value = self.leafPositions[0];
    self.frog.position = [UniversalUtil universaliPadPoint:[self adjustFrogPositionWith:value.CGPointValue]
                                               iPhonePoint:CGPOINT_NON
                                                   offsetX:-20
                                                   offsetY:0];
    self.frog.zPosition = zPostionCharacter + 10;
    self.frog.allJumpPositions = [NSMutableArray arrayWithArray:self.leafPositions];
    [self.riverLayer1 addChild:self.frog];
    
    self.emptyLeaf = [SKSpriteNode spriteNodeWithImageNamed:@"leaf_empty"];
    self.emptyLeaf.position = [UniversalUtil universaliPadPoint:value.CGPointValue
                                                    iPhonePoint:CGPOINT_NON
                                                        offsetX:0
                                                        offsetY:0];
    self.emptyLeaf.zPosition = zPostionCharacter;
    [self.riverLayer1 addChild:self.emptyLeaf];
    
    self.emptyLeaf2 = [self.emptyLeaf copy];
    [self.riverLayer2 addChild:self.emptyLeaf2];
    
    // Question Leafs
    for (int i = 0; i < 6; i++) {
        NSInteger idx = i;
        idx = idx - 3 > 0 ? idx - 3 : idx;
        
        HSLabelSprite *leaf = [[HSLabelSprite alloc] initWithTexture:[SKTexture textureWithImageNamed:@"leaf1"]
                                                               title:@""];
        leaf.zPosition = zPostionCharacter;
        NSValue *value = self.leafPositions[i / 3];
        leaf.position = [UniversalUtil universaliPadPoint:value.CGPointValue
                                              iPhonePoint:CGPOINT_NON
                                                  offsetX:-40
                                                  offsetY:0];
        leaf.label.fontColor = [UIColor whiteColor];
        leaf.label.fontSize = [UniversalUtil universalFontSize:50.];
        
        if (i - 3 < 0) {
            [self.riverLayer1 addChild:leaf];
        }
        else {
            [self.riverLayer2 addChild:leaf];
        }
        
        if (self.questionLeafs.count < (i / 3) + 1) {
            NSMutableArray *array = [NSMutableArray array];
            [self.questionLeafs addObject:array];
        }
        
        NSMutableArray *array = self.questionLeafs[(i / 3)];
        [array addObject:leaf];
    }
    
    // Option Leafs
    for (int i = 0 ; i < 4; i++) {
        OptionLeaf *leaf = [[OptionLeaf alloc] initWithTexture:[SKTexture textureWithImageNamed:@"leaf1"]
                                                         title:@""];
        leaf.zPosition = zPostionCharacter;
//        leaf.originalLocation = CGPointMake(self.optionBackground.position.x + self.optionBackground.size.width / 2,
//                                            self.optionBackground.position.y - self.optionBackground.size.height + [UniversalUtil universalDelta:105 * i + leaf.size.height + 40]);
        leaf.originalLocation = CGPointMake(self.optionBackground.position.x + self.optionBackground.size.width / 2,
                                            self.optionBackground.position.y - self.optionBackground.size.height + [UniversalUtil universalDelta:105 * i + 30] + leaf.size.height / 2);
        leaf.position = leaf.originalLocation;
        leaf.label.fontColor = [UIColor whiteColor];
        leaf.label.fontSize = [UniversalUtil universalFontSize:50.];
        leaf.name = kOptionLeaf;
        [self addNode:leaf atWorldLayer:HSSWorldLayerControl];
        [self.optionLeafs addObject:leaf];
    }
}

- (void)checkAnswerWith:(OptionLeaf *)leaf {
    CGFloat distance = DistanceBetweenPoints(self.fitLocation, leaf.position);
    if (distance <= [UniversalUtil universalDelta:30]) {
        leaf.position = self.fitLocation;
        self.myGameMgr.isAnswer = leaf.isAnswer;
        self.myGameMgr.stat = JZBStatStartChecking;
    }
    else {
        leaf.position = leaf.originalLocation;
        self.draggingLeaf = nil;
    }
}

- (void)checkShouldGoNext {
    if (self.isFrogAnimationFinish && self.isSpeakingFinish) {
        self.userInteractionEnabled = NO;
        [self performSelector:@selector(next) withObject:nil afterDelay:0];
    }
}

- (CGFloat)fallDownDurationFromY:(CGFloat)fromY toY:(CGFloat)toY {
    CGFloat distance = fabs(fromY - toY);
    
    return FALL_DOWN_STANDARD_TIME * distance / self.size.height / 2;
}

- (void)frogJump {
    if ([self.frog isJumpCompletion]) {
        self.myGameMgr.stat = JZBStatDoCheckResult;
    }
    else {
        [self.frog jump];
    }
}

- (void)frogFallDown {
    [self playSound:@"jzb_frog_falldown.mp3" completion:nil];
    
    SKAction *frogMoveAction = [SKAction moveToY:[UniversalUtil universalDelta:-100]
                                        duration:[self fallDownDurationFromY:self.frog.position.y toY:[UniversalUtil universalDelta:-100]]];
    SKAction *leafMoveAction = [SKAction moveToY:[UniversalUtil universalDelta:-100]
                                        duration:[self fallDownDurationFromY:self.draggingLeaf.position.y toY:[UniversalUtil universalDelta:-100]]];
    
    [self.frog runAction:frogMoveAction completion:^{
        NSValue *value = self.leafPositions.firstObject;
        self.frog.curLocationIndex = 0;
        self.frog.position = [UniversalUtil universaliPadPoint:[self adjustFrogPositionWith:value.CGPointValue]
                                                   iPhonePoint:CGPOINT_NON
                                                       offsetX:0
                                                       offsetY:0];
    }];
    [self.draggingLeaf runAction:leafMoveAction
                      completion:^{
                          [self addCharacters:self.curIndex];
                      }];
}

- (void)frogStartWithRiverLayer:(SKNode *)riverLayer {
    [self.frog removeFromParent];
    
    NSValue *value = self.leafPositions.firstObject;
    CGPoint startPosition = value.CGPointValue;
    
    self.frog.position = [UniversalUtil universaliPadPoint:CGPointMake(-80, startPosition.y)
                                               iPhonePoint:CGPointMake(-40, startPosition.y)
                                                   offsetX:0
                                                   offsetY:0];
    [riverLayer addChild:self.frog];
    
    [self.frog runAction:[SKAction moveTo:[UniversalUtil universaliPadPoint:[self adjustFrogPositionWith:startPosition]
                                                                iPhonePoint:CGPOINT_NON
                                                                    offsetX:-20
                                                                    offsetY:0]
                                 duration:0.3]];
}

- (void)frogHappy {
    [self.frog animationHappyCompletion:^{
        self.isFrogAnimationFinish = YES;
        [self checkShouldGoNext];
    }];
}

- (void)gameBegain {
    self.curIndex = 0;
    [self addCharacters:0];
}

- (BOOL)isButtonWithName:(NSString *)name {
    return ([name isEqualToString:kLeftButton] || [name isEqualToString:kRightButton] || [name isEqualToString:kBackButton]);
}

- (void)loadGameMgr {
    self.myGameMgr = [[JZBMgr alloc] init];
    self.myGameMgr.gameScene = self;
}

- (void)setFrogJumpTarget:(NSInteger)index {
    self.frog.targetLocationIndex = index;
}

- (void)next {
    self.userInteractionEnabled = YES;
    self.curIndex++;
}

#pragma mark - Override
+ (void)loadSceneAssets {
    [JZBFrog loadAssets];
}

+ (void)releaseSceneAssets {}

- (void)addCharacters:(NSInteger)index {
    [super addCharacters:index];
    
    if (self.myGameMgr.models.count == 0 ||
        index >= self.gameMgr.models.count) {
        return;
    }
    
    JZBModel *model = self.myGameMgr.models[index];
    JZBQuestion *question = model.question;
    self.myGameMgr.questionIndex = question.questionIndex;
    
    NSInteger riverIndex = self.riverLayer1.position.x == 0 ? 1 : 0;
    if (self.lastIndex == self.curIndex) {
        riverIndex = riverIndex == 0 ? 1 : 0;
    }
    
    NSMutableArray *questionLeafs = self.questionLeafs[riverIndex];
    NSUInteger j = 0;
    for (int i = 0; i < question.titles.count + 1; i++) {
        NSValue *value = self.leafPositions[i];
        if (i == question.questionIndex) {
            SKSpriteNode *theLeaf = riverIndex == 0 ? self.emptyLeaf : self.emptyLeaf2;
            theLeaf.position = [UniversalUtil universaliPadPoint:value.CGPointValue
                                                     iPhonePoint:CGPOINT_NON
                                                         offsetX:-20
                                                         offsetY:0];
            self.fitLocation = theLeaf.position;
            
            continue;
        }
        
        NSString *character = question.titles[j];
        HSLabelSprite *leaf = questionLeafs[j];
        leaf.position = [UniversalUtil universaliPadPoint:value.CGPointValue
                                              iPhonePoint:CGPOINT_NON
                                                  offsetX:-20
                                                  offsetY:0];
        leaf.label.text = character;
        j++;
    }
    
    self.fakeLeaf = [self.draggingLeaf copy];
    
    for (int i = 0; i < self.optionLeafs.count; i++) {
        JZBOption *option = model.options[i];
        OptionLeaf *leaf = self.optionLeafs[i];
        leaf.label.text = option.title;
        leaf.isAnswer = option.isAnswer;
    }
    
    self.frog.curLocationIndex = 0;
    
    if (self.lastIndex < self.curIndex) {
        self.worldMoveDirection = MOVE_RIGHT;
    }
    else if (self.lastIndex > self.curIndex) {
        self.worldMoveDirection = MOVE_LEFT;
    }
    else {
        self.worldMoveDirection = 0;
    }
    
    if (self.lastIndex != self.curIndex) {
        SKNode *theRiver = riverIndex == 1 ? self.riverLayer2 : self.riverLayer1;
        SKNode *standardRiver = riverIndex == 1 ? self.riverLayer1 : self.riverLayer2;
        theRiver.position = CGPointMake(standardRiver.position.x + self.worldMoveDirection * self.size.width,
                                        standardRiver.position.y);
        self.river1StartMovingPosition = self.riverLayer1.position;
        self.river2StartMovingPosition = self.riverLayer2.position;
        
        if (self.fakeLeaf) {
            [standardRiver addChild:self.fakeLeaf];
        }
        
        self.isWorldMoving = YES;
        self.lastIndex = self.curIndex;
    }
    
    self.draggingLeaf.position = self.draggingLeaf.originalLocation;
    self.draggingLeaf = nil;
}

- (void)addIndexController {
    [super addIndexController];
    
    [self.indexController registerNib:[UINib nibWithNibName:@"StepCell" bundle:nil]
           forCellWithReuseIdentifier:@"StepCell"];
    
    UIView *bgView = [self.uikitContainer viewWithTag:1000];
    bgView.hidden = YES;
}

- (void)destroyCharacters {}

- (NSString *)indexStringWith:(NSInteger)index {
    JZBModel *model = self.myGameMgr.models[index];
    
    return model.indexStr;
}

- (NSInteger)currentTotalCount {
    return self.myGameMgr.models.count;
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

- (void)setIndexControllerFocusOldIndex:(NSIndexPath *)oldIndex currentIndex:(NSIndexPath *)currentIndex {
    StepCell *oldCell = (StepCell *)[self.indexController cellForItemAtIndexPath:oldIndex];
    [oldCell.stepBtn setTitleColor:[UIColor whiteColor]
                          forState:UIControlStateNormal];
    StepCell *newCell = (StepCell *)[self.indexController cellForItemAtIndexPath:currentIndex];
    [newCell.stepBtn setTitleColor:colorRGB(255, 0, 0, 1)
                          forState:UIControlStateNormal];
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
    [self.myGameMgr.models removeAllObjects];
    GameSelectScene *scene = [[GameSelectScene alloc] initWithSize:self.size];
    [self.view presentScene:scene];
}

#pragma mark - Loop
- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)interval {
    self.view.userInteractionEnabled = !self.isWorldMoving;
    
    if (self.isWorldMoving) {
        CGPoint river1Pos = CGPointMake(self.riverLayer1.position.x - self.worldMoveDirection * WORLD_MOVE_SPEED,
                                        self.riverLayer1.position.y);
        CGPoint river2Pos = CGPointMake(self.riverLayer2.position.x - self.worldMoveDirection * WORLD_MOVE_SPEED,
                                        self.riverLayer2.position.y);
        if (fabs(river1Pos.x - self.river1StartMovingPosition.x) >= self.size.width) {
            river1Pos.x = self.river1StartMovingPosition.x - self.worldMoveDirection * self.size.width;
        }
        if (fabs(river2Pos.x - self.river2StartMovingPosition.x) >= self.size.width) {
            river2Pos.x = self.river2StartMovingPosition.x - self.worldMoveDirection * self.size.width;
        }
        
        if (river2Pos.x == self.river2StartMovingPosition.x - self.worldMoveDirection * self.size.width &&
            river1Pos.x == self.river1StartMovingPosition.x - self.worldMoveDirection * self.size.width) {
            self.isWorldMoving = NO;
            [self frogStartWithRiverLayer:river1Pos.x == 0 ? self.riverLayer1 : self.riverLayer2];
            
            [self.fakeLeaf removeFromParent];
            self.fakeLeaf = nil;
        }
        
        self.riverLayer1.position = river1Pos;
        self.riverLayer2.position = river2Pos;
    }
    
    [self.myGameMgr gameLogic:interval];
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self currentTotalCount];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return [UniversalUtil universaliPadSize:CGSizeMake(166, 99) iPhoneSize:CGSizeMake(110, 50)];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    StepCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StepCell"
                                                               forIndexPath:indexPath];
    [cell.stepBtn setTitle:[NSString stringWithFormat:@"%@", @(indexPath.row + 1)]
                  forState:UIControlStateNormal];
    [cell.stepBtn setTitleColor:[UIColor whiteColor]
                       forState:UIControlStateNormal];
    cell.stepBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_HP size:[UniversalUtil universalFontSize:40]];
    if (indexPath.row == self.curIndex) {
        [cell.stepBtn setTitleColor:colorRGB(255, 0, 0, 1)
                           forState:UIControlStateNormal];
    }
    
    if (indexPath.row % 4 == 0 || indexPath.row % 4 == 1) {
        [cell setStepBtnOffsetY:0];
        [cell setPointOffsetY:0];
    }
    else if (indexPath.row % 4 == 2) {
        [cell setStepBtnOffsetY:[UniversalUtil universalDelta:10]];
        [cell setPointOffsetY:[UniversalUtil universalDelta:5]];
    }
    else if (indexPath.row % 4 == 3) {
        [cell setStepBtnOffsetY:[UniversalUtil universalDelta:-10]];
        [cell setPointOffsetY:[UniversalUtil universalDelta:-5]];
    }
    
    if (indexPath.row == [self currentTotalCount] - 1) {
        [cell setPointHidden:YES];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    StepCell *cell = (StepCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell.stepBtn setTitleColor:colorRGB(255, 0, 0, 1)
                       forState:UIControlStateNormal];
    self.curIndex = indexPath.row;
}

#pragma mark - Touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint loc = [touch locationInNode:self];
    
    SKNode *node = [self nodeAtPoint:loc];
    NSString *name = node.name;
    
    if ([name isEqualToString:kOptionLeaf] && !self.isDraggingLeaf) {
        self.isDraggingLeaf = YES;
        self.draggingLeaf = [OptionLeaf optionLeafWithNode:node];
    }
    else if ([self isButtonWithName:name]) {
        [self setButtonSelectState:name];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.isDraggingLeaf) {
        UITouch *touch = [touches anyObject];
        CGPoint loc = [touch locationInNode:self];
        self.draggingLeaf.position = loc;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint loc = [touch locationInNode:self];
    
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
    else if (self.isDraggingLeaf) {
        [self checkAnswerWith:self.draggingLeaf];
    }
    
    [self setButtonSelectState:nil];
    
    self.isDraggingLeaf = NO;
    
    [super touchesEnded:touches withEvent:event];
}

#pragma mark - Property
- (NSMutableArray *)questionLeafs {
    if (!_questionLeafs) {
        _questionLeafs = [NSMutableArray arrayWithCapacity:3];
    }
    
    return _questionLeafs;
}

- (NSMutableArray *)optionLeafs {
    if (!_optionLeafs) {
        _optionLeafs = [NSMutableArray arrayWithCapacity:4];
    }
    
    return _optionLeafs;
}

- (NSArray *)leafPositions {
    if (!_leafPositions) {
        _leafPositions = [NSArray array];
    }
    
    return _leafPositions;
}

- (void)setMyGameMgr:(JZBMgr *)myGameMgr {
    _myGameMgr = myGameMgr;
    self.gameMgr = myGameMgr;
}

@end
