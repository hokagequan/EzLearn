//
//  DDSGopher.m
//  EasyLSP
//
//  Created by Q on 15/5/26.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "DDSGopher.h"

#define kGROPHER_MOVING @"GROPHER_MOVING"

@interface DDSGopher()

@property (strong, nonatomic) SKSpriteNode *sprite;
@property (strong, nonatomic) SKSpriteNode *mask;
@property (strong, nonatomic) HSLabelSprite *card;
@property (strong, nonatomic) SKTexture *idleTexture;
@property (strong, nonatomic) SKTexture *smileTexture;
@property (strong, nonatomic) SKTexture *cryTexture;

@end

@implementation DDSGopher

- (instancetype)initWithTexture:(SKTexture *)texture smileTexture:(SKTexture *)smileTexture cryTexture:(SKTexture *)cryTexture {
    if (self = [super init]) {
        self.idleTexture = texture;
        self.smileTexture = smileTexture;
        self.cryTexture = cryTexture;
        
        [self doCreateSprite:texture];
        [self doMask];
    }
    
    return self;
}

- (SKAction *)spriteShowUpAction {
    return [SKAction moveByX:0 y:self.size.height duration:0.3];
//    return [SKAction moveToY:self.position.y + self.size.height duration:0.3];
}

- (SKAction *)maskShowUpAction {
    return [SKAction resizeToHeight:self.size.height duration:0.3];
}

- (SKAction *)spriteHideDownAction {
    return [SKAction moveByX:0 y:-self.size.height duration:0.5];
}

- (SKAction *)maskHideDownAction {
    return [SKAction resizeToHeight:0 duration:0.5];
}

- (void)doCreateSprite:(SKTexture *)texture {
    self.sprite = [[SKSpriteNode alloc] initWithTexture:texture];
    
//    self.card = [[HSLabelSprite alloc] initWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"dadishu_card"]]
//                                                 title:@""];
//    self.card.label.fontColor = [UIColor redColor];
//    self.card.label.fontSize = 50.;
//    self.card.position = CGPointMake(0, -65);
//    [self.sprite addChild:self.card];
    
    [self addChild:self.sprite];
}

- (void)doMask {
    self.mask = [[SKSpriteNode alloc] initWithColor:[UIColor blackColor]
                                               size:self.size];
    self.mask.anchorPoint = CGPointMake(0, 1);
    self.mask.position = CGPointMake(-self.size.width / 2, self.size.height / 2);
    self.maskNode = self.mask;
}

- (void)hideAndShowWithPosition:(CGPoint)position text:(NSString *)text completion:(void (^)(void))completion {
    SKAction *waitAction = [SKAction waitForDuration:0.3];
    SKAction *moveToAction = [SKAction moveTo:position duration:0.0];
    SKAction *changeTextAction = [SKAction runBlock:^{
        [self setStat:GopherStatNormal];
        [self setCardText:text];
    }];
    
    [self runAction:[SKAction sequence:@[[self spriteHideDownAction],
                                         [SKAction group:@[moveToAction, changeTextAction]],
                                         waitAction,
                                         [self spriteShowUpAction]]] withKey:kGROPHER_MOVING];
    [self.mask runAction:[SKAction sequence:@[[self maskHideDownAction],
                                              waitAction,
                                              [self maskShowUpAction]]]
              completion:^{
                  if (completion) {
                      completion();
                  }
              }];
}

- (void)hideDown {
    [self runAction:[self spriteHideDownAction]];
    [self.mask runAction:[self maskHideDownAction]];
}

- (BOOL)isMoving {
    return [self actionForKey:kGROPHER_MOVING] != nil;
}

- (void)showUp {
    [self runAction:[self spriteShowUpAction]];
    [self.mask runAction:[self maskShowUpAction]];
}

- (void)setCardText:(NSString *)text {
    if (!self.card) {
        return;
    }
    
    self.card.label.text = text;
}

- (void)setStat:(GopherStat)stat {
    switch (stat) {
        case GopherStatNormal:
            self.sprite.texture = self.idleTexture;
            break;
        case GopherStatSmile:
            self.sprite.texture = self.smileTexture;
            break;
        case GopherStatCry:
            self.sprite.texture = self.cryTexture;
            break;
            
        default:
            break;
    }
}

#pragma mark - Property
- (CGSize)size {
    CGSize theSize = self.sprite.size;
    
    if (self.card) {
        theSize = CGSizeMake(MAX(self.sprite.size.width, self.card.size.width),
                             MAX(self.sprite.size.height, self.sprite.size.height / 2 - (self.card.position.y - self.card.size.height / 2)));
    }
    
    return theSize;
}

@end
