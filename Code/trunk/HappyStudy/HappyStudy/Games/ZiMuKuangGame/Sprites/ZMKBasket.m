//
//  ZMKBasket.m
//  EasyLSP
//
//  Created by Q on 15/7/23.
//  Copyright © 2015年 LittleIsland. All rights reserved.
//

#import "ZMKBasket.h"

@interface ZMKBasket()

@property (strong, nonatomic) NSMutableArray *fruits;

@end

@implementation ZMKBasket

- (void)animationRemoveFruit:(HSLabelSprite *)fruit {
    SKAction *scaleAction = [SKAction scaleTo:0.0 duration:0.3];
    SKAction *rotateAction = [SKAction rotateByAngle:M_PI * 2 duration:0.2];
    SKAction *doneAction = [SKAction runBlock:^{
        [fruit removeFromParent];
    }];
    SKAction *groupAction = [SKAction group:@[scaleAction, [SKAction repeatActionForever:rotateAction]]];
    [fruit runAction:[SKAction sequence:@[groupAction, doneAction]]];
}

- (void)addFruit:(HSLabelSprite *)fruit {
    // 添加水果在篮子两侧
//    BOOL addToLeft = self.fruits.count == 0;
//    CGPoint position = CGPointMake(-self.size.width / 2 - fruit.size.width / 2, -self.size.height / 2 + fruit.size.height / 2);
//    
//    if (!addToLeft) {
//        position = CGPointMake(self.size.width / 2 + fruit.size.width / 2, -self.size.height / 2 + fruit.size.height / 2);
//    }
//    
//    fruit.position = position;
//    fruit.zPosition = 200;
//    
//    [self addChild:fruit];
//    [self.fruits addObject:fruit];
    
    [fruit setScale:0.7];
    BOOL addToLeft = self.fruits.count == 0;
    CGPoint position = CGPointMake(-self.size.width / 2 + fruit.size.width * 2 / 3, [UniversalUtil universalDelta:20]);
    
    if (!addToLeft) {
        position = CGPointMake(self.size.width / 2 - fruit.size.width * 2 / 3, [UniversalUtil universalDelta:20]);
    }
    
    fruit.position = position;
    fruit.zPosition = 90;
    
    [self addChild:fruit];
    [self.fruits addObject:fruit];
}

- (void)clean {
    for (HSLabelSprite *fruit in self.fruits) {
        [self animationRemoveFruit:fruit];
    }
    
    [self.fruits removeAllObjects];
}

- (void)loadUIWithName:(NSString *)name {
    SKSpriteNode *outter = [SKSpriteNode spriteNodeWithImageNamed:@"basket_outter"];
    outter.zPosition = 100;
    outter.name = name;
    [self addChild:outter];

    SKSpriteNode *inner = [SKSpriteNode spriteNodeWithImageNamed:@"basket_inner"];
    inner.zPosition = 0;
    inner.name = name;
    inner.position = CGPointMake(0, inner.size.height + [UniversalUtil universalDelta:6]);
    [self addChild:inner];
}

- (void)removeSingleFruit {
    HSLabelSprite *fruit = self.fruits.lastObject;
    if (!fruit) {
        return;
    }
    
    [self animationRemoveFruit:fruit];
    [self.fruits removeObject:fruit];
}

#pragma mark - Property
- (NSMutableArray *)fruits {
    if (!_fruits) {
        _fruits = [NSMutableArray array];
    }
    
    return _fruits;
}

@end
