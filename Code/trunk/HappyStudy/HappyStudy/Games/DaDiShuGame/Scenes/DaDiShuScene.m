//
//  DaDiShuScene.m
//  EasyLSP
//
//  Created by Q on 15/4/7.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "DaDiShuScene.h"
#import "GameSelectScene.h"
#import "GameSelectIndividualScene.h"
#import "DDSHoleTypeOne.h"
#import "DDSHoleTypeTwo.h"
#import "DaDiShuIndexCell.h"
#import "AccountMgr.h"
#import "DDSModel.h"
#import "GameMgr.h"
#import "SKNode+PlaySound.h"

@interface DaDiShuScene()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIAlertViewDelegate>

@property (strong, nonatomic) NSMutableArray *dynamicHoles;

@end

@implementation DaDiShuScene
@synthesize curIndex = _curIndex;

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.holePostions = @[[NSValue valueWithCGRect:CGRectMake(240, 300, -M_PI / 12, 1)],
                              [NSValue valueWithCGRect:CGRectMake(396, 120, 0, 0)],
                              [NSValue valueWithCGRect:CGRectMake(460, 330, 0, 0)],
                              [NSValue valueWithCGRect:CGRectMake(340, 435, 0, 0)],
                              [NSValue valueWithCGRect:CGRectMake(596, 230, M_PI / 12, 1)],
                              [NSValue valueWithCGRect:CGRectMake(670, 422, 0, 0)],
                              [NSValue valueWithCGRect:CGRectMake(900, 240, -M_PI / 12, 0)],
                              [NSValue valueWithCGRect:CGRectMake(920, 410, 0, 1)],
                              [NSValue valueWithCGRect:CGRectMake(835, 500, 0, 0)]];
        self.gopherPositions = @[[NSValue valueWithCGRect:CGRectMake(240, 300, -M_PI / 12, 1)],
                                 [NSValue valueWithCGRect:CGRectMake(380, 120, 0, 0)],
                                 [NSValue valueWithCGRect:CGRectMake(440, 330, 0, 0)],
                                 [NSValue valueWithCGRect:CGRectMake(320, 435, 0, 0)],
                                 [NSValue valueWithCGRect:CGRectMake(626, 230, M_PI / 12, 1)],
                                 [NSValue valueWithCGRect:CGRectMake(650, 422, 0, 0)],
                                 [NSValue valueWithCGRect:CGRectMake(875, 240, -M_PI / 12, 0)],
                                 [NSValue valueWithCGRect:CGRectMake(935, 410, 0, 1)],
                                 [NSValue valueWithCGRect:CGRectMake(820, 500, 0, 0)]];
    }
    
    return self;
}

- (void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    
    self.pageCount = self.myGameMgr.models.count;
    
    [self addControllers];
    [self buildWorld];
    [self.myGameMgr gameStart];
}

- (void)willMoveFromView:(SKView *)view {
    [super willMoveFromView:view];
}

- (void)addIndexController {
    [super addIndexController];
    
    [self.indexController registerNib:[UINib nibWithNibName:@"DaDiShuIndexCell" bundle:nil]
           forCellWithReuseIdentifier:@"DaDiShuIndexCell"];
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
    SKSpriteNode *backgroundSp = [SKSpriteNode spriteNodeWithImageNamed:@"dadishu_background"];
    backgroundSp.anchorPoint = CGPointZero;
    backgroundSp.position = CGPointZero;
    backgroundSp.zPosition = zPostionBackground;
    backgroundSp.size = self.size;
    [self addNode:backgroundSp atWorldLayer:HSSWorldLayerGround];
    
    // Holes
    for (int i = 0; i < self.holePostions.count; i++) {
        NSValue *value = self.holePostions[i];
        CGRect rect = [value CGRectValue];
        
        CGFloat deltaY = 24.5;
        if (rect.size.height == 0) {
            deltaY = 26;
        }
        
        CGFloat deltaX = 0.0;
        if (rect.size.width > 0) {
            deltaX = 12;
            deltaY = 23.5;
        }
        else if (rect.size.width < 0) {
            deltaX = -12;
            deltaY = 23.5;
        }
        
        HSCharacter *hole = [[[self classOfType:rect.size.height] alloc] initWithTexture:nil];
        hole.zPosition = zPostionHoleBehind;
        hole.position = [UniversalUtil universaliPadPoint:CGPointMake(rect.origin.x, rect.origin.y + hole.size.height / 2)
                                              iPhonePoint:CGPOINT_NON
                                                  offsetX:-20
                                                  offsetY:-30];
        hole.zRotation = rect.size.width;
        hole.requestedAnimation = HSAnimationStateIdle;
        [self addNode:hole atWorldLayer:HSSWorldLayerCharacter];
        [self.dynamicHoles addObject:hole];
        
        SKSpriteNode *holeFront = [[SKSpriteNode alloc] initWithImageNamed:[NSString stringWithFormat:@"ddshole_front%d", (int)rect.size.height]];
        holeFront.zPosition = zPostionHoleBehind;
//        holeFront.position = [UniversalUtil universaliPadPoint:CGPointMake(rect.origin.x + deltaX, rect.origin.y - deltaY)
//                                                   iPhonePoint:CGPOINT_NON
//                                                       offsetX:-20
//                                                       offsetY:-28];
        holeFront.position = CGPointMake(hole.position.x,
                                         hole.position.y - holeFront.size.height / 2 - hole.size.height/ 2);
        holeFront.zRotation = rect.size.width;
        [self addNode:holeFront atWorldLayer:HSSWorldLayerCharacter];
    }
    
    // Characters
    for (int i = 0; i < 4; i++) {
        DDSGopher *gopher = [[DDSGopher alloc] initWithTexture:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"dishu%d", i + 1]]
                                                  smileTexture:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"dishu_smile%d", i + 1]]
                                                    cryTexture:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"dishu_cry%d", i + 1]]];
        gopher.alpha = 0.0;
        gopher.zPosition = zPostionCharacter;
        [self addNode:gopher atWorldLayer:HSSWorldLayerCharacter];
        [self.characters addObject:gopher];
    }
    
    // Cards
    for (int i = 0; i < 4; i++) {
        HSLabelSprite *card = [[HSLabelSprite alloc] initWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"dadishu_card"]]
                                                               title:@""];
        card.size = [UniversalUtil universaliPadSize:CGSizeMake(99, 99)
                                          iPhoneSize:CGSIZE_NON];
        card.alpha = 0.0;
        card.zPosition = zPostionFront;
        card.label.fontColor = [UIColor redColor];
        card.label.fontSize = [UniversalUtil universalFontSize:40.];
        card.label.fontName = FONT_NAME_HP;
        [self addNode:card atWorldLayer:HSSWorldLayerCharacter];
        [self.cards addObject:card];
    }
}

- (Class)classOfType:(NSInteger)type {
    switch (type) {
        case 0:
            return [DDSHoleTypeOne class];
        case 1:
            return [DDSHoleTypeTwo class];
            
        default:
            return [DDSHoleTypeOne class];
    }
}

- (void)checkTouchWithLocation:(CGPoint)location {
    for (int i = 0; i < self.characters.count; i++) {
        HSCharacter *character = self.characters[i];
        if ([character containsPoint:location]) {
            if ([self isGopherMovingWithIndex:i]) {
                return;
            }
            
            [self.myGameMgr checkAnswerWith:i];
            
            break;
        }
        
        HSLabelSprite *card = self.cards[i];
        if ([card containsPoint:location]) {
            if ([self isGopherMovingWithIndex:i]) {
                return;
            }
            
            [self.myGameMgr checkAnswerWith:i];
            
            break;
        }
    }
}

- (void)changeCharacterStat:(GopherStat)stat index:(NSInteger)index {
    DDSGopher *gopher = self.characters[index];
    [gopher setStat:stat];
}

- (void)changeLifeWith:(NSInteger)life {}

- (BOOL)isGopherMovingWithIndex:(NSInteger)index {
    DDSGopher *gopher = self.characters[index];
    return [gopher isMoving];
}

- (void)loadGameMgr {
    self.myGameMgr = [[DDSMgr alloc] init];
    self.myGameMgr.gameScene = self;
}

- (NSArray *)randomPosition {
    NSMutableArray *positions = [NSMutableArray arrayWithCapacity:9];
    NSMutableArray *sourcePositions = [NSMutableArray arrayWithArray:self.gopherPositions];
    
    while (positions.count < self.gopherPositions.count) {
        NSUInteger random = [GlobalUtil randomIntegerWithMax:sourcePositions.count];
        [positions addObject:sourcePositions[random]];
        [sourcePositions removeObjectAtIndex:random];
    }
    
    return positions;
}

#pragma mark - Override
+ (void)loadSceneAssets {
    [DDSHoleTypeOne loadAssets];
    [DDSHoleTypeTwo loadAssets];
}

+ (void)releaseSceneAssets {}

- (void)addCharacters:(NSInteger)index {
    if (self.myGameMgr.models.count <= index) {
        return;
    }
    
    NSArray *positions = [self randomPosition];
    DDSModel *model = self.myGameMgr.models[index];
#ifdef EZLEARN_DEBUG
#else
    [self playSound:model.question.sound completion:^{
        
    }];
#endif
    
    for (int i = 0; i < self.characters.count; i++) {
        DDSGopher *character = self.characters[i];
        character.alpha = 1.0;
        
        HSLabelSprite *card = self.cards[i];
        card.alpha = 0.0;
        
        NSValue *value = positions[i];
        CGRect rect = [value CGRectValue];
        DDSOption *option = model.options[i];
        
        [character hideAndShowWithPosition:[UniversalUtil universaliPadPoint:CGPointMake(rect.origin.x, rect.origin.y - character.size.height / 2 - 20)
                                                                 iPhonePoint:CGPOINT_NON
                                                                     offsetX:-20
                                                                     offsetY:-30]
                                      text:option.title
                                completion:^{
                                    DDSOption *option = model.options[i];
                                    card.label.text = option.title;
                                    card.position = [UniversalUtil universaliPadPoint:CGPointMake(rect.origin.x, rect.origin.y - 40)
                                                                          iPhonePoint:CGPOINT_NON
                                                                              offsetX:-20
                                                                              offsetY:-22];
                                    card.alpha = 1.0;
                                }];
    }
}

- (void)destroyCharacters {}

- (NSString *)indexStringWith:(NSInteger)index {
    DDSModel *model = self.myGameMgr.models[index];
    
    return model.question.title;
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

- (void)finishAll {
    [super finishAll];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"Finish All!"
                                                   delegate:self 
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
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
    
    if ([GameMgr sharedInstance].gameGroup == GroupIndividual) {
        GameSelectIndividualScene *scene = [[GameSelectIndividualScene alloc] initWithSize:self.size];
        [self.view presentScene:scene];
    }
    else if ([GameMgr sharedInstance].gameGroup == GroupSchool) {
        GameSelectScene *scene = [[GameSelectScene alloc] initWithSize:self.size];
        [self.view presentScene:scene];
    }
}

#pragma mark - AlertView
- (void)alertView:(nonnull UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self clickBack:nil];
    }
}

#pragma mark - Loop
- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)interval {
    for (HSCharacter *hole in self.dynamicHoles) {
        [hole updateWithTimeSinceLastUpdate:interval];
    }
    
    [self.myGameMgr gameLogic:interval];
}

#pragma mark - Observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
    if ([keyPath isEqualToString:@"curIndex"]) {
        self.myGameMgr.missTimes = 0;
    }
}

#pragma mark - Touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint loc = [touch locationInNode:self];
    
    SKNode *node = [self nodeAtPoint:loc];
    NSString *buttonName = node.name;
    [self setButtonSelectState:buttonName];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {}

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
    else if (![self.myGameMgr isGameEnd]) {
        [self checkTouchWithLocation:loc];
    }
    
    [self setButtonSelectState:nil];
    
    [super touchesEnded:touches withEvent:event];
}

#pragma mark - CollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self currentTotalCount];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = [super collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
    
    return CGSizeMake(size.width + [UniversalUtil universalDelta:53], size.height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return [UniversalUtil universalDelta:21.];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DaDiShuIndexCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DaDiShuIndexCell"
                                                                       forIndexPath:indexPath];
    cell.titleLab.font = [UIFont fontWithName:FONT_NAME_HP size:[UniversalUtil universalFontSize:60]];
    cell.titleLab.text = [self indexStringWith:indexPath.row];
    cell.titleLab.textColor = colorRGB(255, 240, 210, 1);
    if (indexPath.row == self.curIndex) {
        cell.titleLab.textColor = colorRGB(255, 0, 0, 1);
    }
    cell.soundMarkIV.hidden = indexPath.row != self.curIndex;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DaDiShuIndexCell *cell = (DaDiShuIndexCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.titleLab.textColor = colorRGB(255, 0, 0, 1);
    self.curIndex = indexPath.row;
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

- (NSMutableArray *)dynamicHoles {
    if (!_dynamicHoles) {
        _dynamicHoles = [NSMutableArray array];
    }
    
    return _dynamicHoles;
}

- (NSArray *)holePostions {
    if (!_holePostions) {
        _holePostions = [NSArray array];
    }
    
    return _holePostions;
}

- (NSArray *)gopherPositions {
    if (!_gopherPositions) {
        _gopherPositions = [NSArray array];
    }
    
    return _gopherPositions;
}

- (void)setMyGameMgr:(DDSMgr *)myGameMgr {
    _myGameMgr = myGameMgr;
    self.gameMgr = myGameMgr;
}

@end
