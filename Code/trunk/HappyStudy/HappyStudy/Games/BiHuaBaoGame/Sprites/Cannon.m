//
//  Cannon.m
//  EasyLSP
//
//  Created by Quan on 15/5/12.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "Cannon.h"
#import "BiHuaBaoScene.h"

#define PROJECTILE_SPEED 1
#define ROTATE_SPEED (M_PI * 0.01f)

@implementation Cannon

- (BiHuaBaoScene *)characterScene {
    SKScene *scene = [self scene];
    
    if ([scene isKindOfClass:[BiHuaBaoScene class]]) {
        return (BiHuaBaoScene *)scene;
    }
    
    return nil;
}

- (void)faceToLocation:(CGPoint)location {
    CGFloat angel = POLAR_ADJUST(RadiansBetweenPoints(location, self.position));
    self.zRotation = angel;
//    SKAction *rotateAction = [SKAction rotateToAngle:angel duration:0];
//    [self runAction:rotateAction];
}

- (void)fire {
    [self playSound:@"bhb_shoot.mp3" completion:nil];
    
    self.wantFire = NO;
    
    BiHuaBaoScene *scene = [self characterScene];
    CGFloat angel = self.zRotation;
    
    SKSpriteNode *projectile = [SKSpriteNode spriteNodeWithImageNamed:@"projectile"];
    projectile.zPosition = self.zPosition - 1;
    projectile.position = self.position;
    projectile.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width / 2];
    projectile.physicsBody.categoryBitMask = BHBColliderTypeProjectile;
    projectile.physicsBody.collisionBitMask = 0;
    projectile.physicsBody.contactTestBitMask = BHBColliderTypeCard;
    [scene addNode:projectile atWorldLayer:HSSWorldLayerCharacter];
    
    SKAction *moveAction = [SKAction moveByX:-sinf(angel) * [UniversalUtil universalDelta:1000]
                                           y:cosf(angel) * [UniversalUtil universalDelta:1000]
                                    duration:PROJECTILE_SPEED];
    SKAction *removeAction = [SKAction removeFromParent];
    [projectile runAction:[SKAction sequence:@[moveAction, removeAction]]];
}

- (void)rotateLeft {
    self.zRotation += ROTATE_SPEED;
    if (self.zRotation >= M_PI / 2) {
        self.zRotation = M_PI / 2;
    }
}

- (void)rotateRight {
    self.zRotation -= ROTATE_SPEED;
    if (self.zRotation <= -M_PI / 2) {
        self.zRotation = -M_PI / 2;
    }
}

@end
