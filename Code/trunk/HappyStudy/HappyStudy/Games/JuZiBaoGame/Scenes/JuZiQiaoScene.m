//
//  JuZiQiaoScene.m
//  EasyLSP
//
//  Created by Q on 15/6/2.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "JuZiQiaoScene.h"
#import "GameSelectScene.h"
#import "OptionLeaf.h"
#import "StepCell.h"
#import "JZQModel.h"
#import "JZQWord.h"

#define kLeftButton @"leftButton"
#define kRightButton @"rightButton"
#define kBackButton @"backButton"
#define kLEAF @"LEAF"
#define kFROG @"FROG"

#define FALL_DOWN_STANDARD_TIME 1

#define ZOOM_IN_SIZE CGSizeMake(131, 131. * 47 / 161)

@interface JuZiQiaoScene()

@property (strong, nonatomic) SKNode *riverLayer1;
@property (strong, nonatomic) SKSpriteNode *draggingLeaf;

@property (strong, nonatomic) NSMutableArray *leafRandomPositions;
@property (strong, nonatomic) NSMutableArray *emptyLeafs;

@property (nonatomic) CGPoint frogBasePosition;
@property (nonatomic) NSInteger lastIndex;
@property (nonatomic) NSInteger curRiverLayerIndex;
@property (nonatomic) NSInteger worldMoveDirection;
@property (nonatomic) BOOL isDraggingLeaf;
@property (nonatomic) BOOL isWorldMoving;

@end

@implementation JuZiQiaoScene

@synthesize curIndex = _curIndex;

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.leafPositions = @[[NSValue valueWithCGPoint:CGPointMake(95, 356)],
                               [NSValue valueWithCGPoint:CGPointMake(150, 287)]];
        self.leafRandomPositions = [@[[NSValue valueWithCGPoint:CGPointMake(87, 430)],
                                     [NSValue valueWithCGPoint:CGPointMake(302, 420)],
                                     [NSValue valueWithCGPoint:CGPointMake(510, 438)],
                                     [NSValue valueWithCGPoint:CGPointMake(693, 436)],
                                     [NSValue valueWithCGPoint:CGPointMake(872, 474)],
                                     [NSValue valueWithCGPoint:CGPointMake(950, 422)],
                                     [NSValue valueWithCGPoint:CGPointMake(236, 200)],
                                     [NSValue valueWithCGPoint:CGPointMake(444, 188)],
                                     [NSValue valueWithCGPoint:CGPointMake(602, 156)],
                                     [NSValue valueWithCGPoint:CGPointMake(784, 177)],
                                     [NSValue valueWithCGPoint:CGPointMake(957, 285)]] mutableCopy];
        self.frogBasePosition = CGPointMake(929, 163);
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
    return CGPointMake(position.x, position.y + self.frog.size.height / 2 + 8);
}

- (void)attractLeaf:(SKSpriteNode *)leaf {
    for (int i = 0; i < 12; i++) {
        CGPoint attractPosition = [UniversalUtil universaliPadPoint:[self leafPositionWithIndex:i]
                                                        iPhonePoint:CGPOINT_NON
                                                            offsetX:0
                                                            offsetY:0];
        if (DistanceBetweenPoints(leaf.position, attractPosition) <= 20) {
            leaf.position = attractPosition;
            
            [self.myGameMgr loadAnswerWithIndex:[self.questionLeafs indexOfObject:leaf] add:YES];
            
            return;
        }
    }
    
    [self.myGameMgr loadAnswerWithIndex:[self.questionLeafs indexOfObject:leaf] add:NO];
}

- (void)buildWorld {
    self.riverLayer1 = [SKNode node];
    self.riverLayer1.position = CGPointZero;
    [self addNode:self.riverLayer1 atWorldLayer:HSSWorldLayerGround];
    
    SKSpriteNode *backgroundSp = [SKSpriteNode spriteNodeWithImageNamed:@"juziqiao_bg"];
    backgroundSp.anchorPoint = CGPointZero;
    backgroundSp.position = CGPointZero;
    backgroundSp.zPosition = zPostionBackground;
    backgroundSp.size = self.size;
    [self.riverLayer1 addChild:backgroundSp];
    
    // Characters
    self.frog = [[JZBFrog alloc] initWithTexture:nil];
    self.frog.name = kFROG;
    CGPoint position = [UniversalUtil universaliPadPoint:self.frogBasePosition
                                             iPhonePoint:CGPOINT_NON
                                                 offsetX:-20
                                                 offsetY:0];
    self.frog.position = [self adjustFrogPositionWith:position];
    self.frog.zPosition = zPostionCharacter + 10;
    self.frog.allJumpPositions = [NSMutableArray arrayWithArray:self.leafPositions];
    [self.riverLayer1 addChild:self.frog];
    
    SKSpriteNode *baseLeaf = [SKSpriteNode spriteNodeWithImageNamed:@"leaf1"];
    baseLeaf.size = [UniversalUtil universaliPadSize:ZOOM_IN_SIZE
                                          iPhoneSize:CGSIZE_NON];
    baseLeaf.zPosition = zPostionCharacter;
    baseLeaf.position = [UniversalUtil universaliPadPoint:CGPointMake(929, 163)
                                              iPhonePoint:CGPOINT_NON
                                                  offsetX:-20
                                                  offsetY:0];
    [self.riverLayer1 addChild:baseLeaf];
    
    // Empty Leafs
    for (int i = 0; i < 11; i++) {
        CGPoint position = [UniversalUtil universaliPadPoint:[self leafPositionWithIndex:i]
                                                 iPhonePoint:CGPOINT_NON
                                                     offsetX:0
                                                     offsetY:0];
        
        SKSpriteNode *emptyLeaf = [SKSpriteNode spriteNodeWithImageNamed:@"leaf_empty"];
        emptyLeaf.size = [UniversalUtil universaliPadSize:ZOOM_IN_SIZE
                                               iPhoneSize:CGSIZE_NON];
        emptyLeaf.zPosition = zPostionBackground;
        emptyLeaf.position = position;
        [self.riverLayer1 addChild:emptyLeaf];
        [self.emptyLeafs addObject:emptyLeaf];
    }
}

- (CGFloat)fallDownDurationFromY:(CGFloat)fromY toY:(CGFloat)toY {
    CGFloat distance = fabs(fromY - toY);
    
    return FALL_DOWN_STANDARD_TIME * distance / self.size.height / 2;
}

- (void)frogJump {
    [self.frog jump];
}

- (void)frogFallDown {
    [self playSound:@"jzb_frog_falldown.mp3" completion:nil];
    
    SKAction *frogMoveAction = [SKAction moveToY:[UniversalUtil universalDelta:-100]
                                        duration:[self fallDownDurationFromY:self.frog.position.y toY:[UniversalUtil universalDelta:-100]]];
    SKAction *leafMoveAction = [SKAction moveToY:[UniversalUtil universalDelta:-100]
                                        duration:[self fallDownDurationFromY:self.draggingLeaf.position.y toY:[UniversalUtil universalDelta:-100]]];
    
    [self.frog runAction:frogMoveAction completion:^{
        self.frog.position = [self adjustFrogPositionWith:self.frogBasePosition];
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
    [self.frog animationHappyCompletion:nil];
}

- (void)gameBegain {
    self.curIndex = 0;
    [self.myGameMgr gameStart];
}

- (BOOL)isButtonWithName:(NSString *)name {
    return ([name isEqualToString:kLeftButton] || [name isEqualToString:kRightButton] || [name isEqualToString:kBackButton]);
}

- (void)loadGameMgr {
    self.myGameMgr = [[JZQMgr alloc] init];
    self.myGameMgr.gameScene = self;
}

- (CGPoint)leafPositionWithIndex:(NSInteger)index {
    NSInteger row = index / 6;
    NSInteger column = index % 6;
    
    if (row >= self.leafPositions.count) {
        return CGPointZero;
    }
    
    NSValue *value = self.leafPositions[row];
    return CGPointMake(value.CGPointValue.x + 155 * column, value.CGPointValue.y);
}

- (void)loadFrogJumpPositions {
    if (self.frog.allJumpPositions.count > 0) {
        [self.frog.allJumpPositions removeAllObjects];
    }
    
    for (int i = 0; i < self.questionLeafs.count; i++) {
        CGPoint position = [self leafPositionWithIndex:i];
        NSValue *value = [NSValue valueWithCGPoint:position];
        [self.frog.allJumpPositions addObject:value];
    }
    
    self.frog.curLocationIndex = -1;
    
    CGPoint position = [UniversalUtil universaliPadPoint:self.frogBasePosition
                                             iPhonePoint:CGPOINT_NON
                                                 offsetX:-20
                                                 offsetY:0];
    [self.frog.allJumpPositions addObject:[NSValue valueWithCGPoint:position]];
    [self setFrogJumpTarget:self.frog.allJumpPositions.count - 1];
}

- (void)setFrogJumpTarget:(NSInteger)index {
    self.frog.targetLocationIndex = index;
}

#pragma mark - Override
+ (void)loadSceneAssets {
    [JZBFrog loadAssets];
}

+ (void)releaseSceneAssets {}

- (void)addCharacters:(NSInteger)index {
    [self.myGameMgr resetAnswers];
    
    for (HSLabelSprite *sprite in self.questionLeafs) {
        [sprite removeFromParent];
    }
    
    if (self.questionLeafs.count > 0) {
        [self.questionLeafs removeAllObjects];
    }
    
    if (self.myGameMgr.models.count == 0 || index >= self.myGameMgr.models.count) {
        return;
    }
    
    self.frog.position = [self adjustFrogPositionWith:self.frogBasePosition];
    
    JZQModel *model = self.myGameMgr.models[index];
    
    for (int i = 0; i < self.emptyLeafs.count; i++) {
        SKSpriteNode *emptyLeaf = self.emptyLeafs[i];
        emptyLeaf.alpha = i < model.words.count ? 1.0 : 0.0;
    }
    
    // Question Leafs
    for (int i = 0; i < model.words.count; i++) {
        NSValue *value = self.leafRandomPositions[i];
        CGPoint position = value.CGPointValue;
        
        JZQWord *word = model.words[i];
        OptionLeaf *leaf = [[OptionLeaf alloc] initWithTexture:[SKTexture textureWithImageNamed:@"leaf1"]
                                                         title:word.word];
        leaf.name = kLEAF;
        leaf.size = [UniversalUtil universaliPadSize:CGSizeMake(131, 38)
                                          iPhoneSize:CGSIZE_NON];
        leaf.zPosition = zPostionCharacter;
        leaf.position = [UniversalUtil universaliPadPoint:position
                                              iPhonePoint:CGPOINT_NON
                                                  offsetX:0
                                                  offsetY:0];
        leaf.label.fontColor = [UIColor whiteColor];
        leaf.label.fontSize = [UniversalUtil universalFontSize:30];
        leaf.label.fontName = FONT_NAME_HP;
        leaf.label.position = CGPointMake(leaf.label.position.x, leaf.label.position.y + [UniversalUtil universalDelta:10]);
        [self.riverLayer1 addChild:leaf];
        [self.questionLeafs addObject:leaf];
    }
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
    return nil;
}

- (NSInteger)currentTotalCount {
    return self.myGameMgr.models.count;
}

- (void)loadGameDataFrom:(NSInteger)fromPos count:(NSInteger)count Complete:(void (^)(void))complete failure:(void (^)(NSDictionary *))failure {
    [self.myGameMgr loadJuZiQiaoServerGameDataCompletion:complete
                                                 failure:failure];
}

- (void)loadMore {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [self.myGameMgr loadJuZiQiaoServerMoreGameDataCompletion:^{
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
            [self.myGameMgr loadJuZiQiaoServerMoreGameDataCompletion:^{
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
    
    if ([self isButtonWithName:name]) {
        [self setButtonSelectState:name];
    }
    else if ([name isEqualToString:kLEAF]) {
        self.isDraggingLeaf = YES;
        self.draggingLeaf = [OptionLeaf optionLeafWithNode:node];
    }
    else if ([name isEqualToString:kFROG]) {
        self.myGameMgr.stat |= JZQGameStatPrepareCheck;
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
        [self attractLeaf:self.draggingLeaf];
    }
    
    [self setButtonSelectState:nil];
    
    self.isDraggingLeaf = NO;
    self.draggingLeaf = nil;
}

#pragma mark - Property
- (NSMutableArray *)questionLeafs {
    if (!_questionLeafs) {
        _questionLeafs = [NSMutableArray arrayWithCapacity:3];
    }
    
    return _questionLeafs;
}

- (NSArray *)leafPositions {
    if (!_leafPositions) {
        _leafPositions = [NSArray array];
    }
    
    return _leafPositions;
}

- (NSMutableArray *)leafRandomPositions {
    if (!_leafRandomPositions) {
        _leafRandomPositions = [NSMutableArray array];
    }
    
    return _leafRandomPositions;
}

- (void)setMyGameMgr:(JZQMgr *)myGameMgr {
    _myGameMgr = myGameMgr;
    self.gameMgr = myGameMgr;
}

- (NSMutableArray *)emptyLeafs {
    if (!_emptyLeafs) {
        _emptyLeafs = [NSMutableArray array];
    }
    
    return _emptyLeafs;
}

@end
