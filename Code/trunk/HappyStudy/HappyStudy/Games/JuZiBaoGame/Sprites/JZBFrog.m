//
//  JZBFrog.m
//  EasyLSP
//
//  Created by Quan on 15/5/14.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "JZBFrog.h"

#define CONTROL_POINT_H  50

@interface JZBFrog()

@end

@implementation JZBFrog

- (void)animationHappyCompletion:(void (^)())completion {
    CGPoint originalPoint = self.position;
    
    SKTexture *happyTexture = [self happyAnimationFrames].firstObject;
    SKTexture *idleTexture = [self idleAnimationFrames].firstObject;
    CGPoint adjustPoint = CGPointMake(originalPoint.x, originalPoint.y + (happyTexture.size.height - idleTexture.size.height) / 2);
    SKAction *moveAction = [SKAction moveTo:adjustPoint duration:0];
    
    SKAction *action = [SKAction animateWithTextures:[self happyAnimationFrames]
                                        timePerFrame:1.0 / 5.0
                                              resize:YES
                                             restore:YES];
    [self runAction:[SKAction group:@[moveAction, action]]
         completion:^{
             self.position = originalPoint;
             [self runAction:[SKAction setTexture:idleTexture]];
             if (completion) {
                 completion();
             }
         }];
}

- (CGPoint)controlPointFrom:(CGPoint)fPos to:(CGPoint)tPos {
    double a = atan(fabs(tPos.y - fPos.y) / fabs(tPos.x - fPos.x));
    double b = M_PI / 2 - a;
    
    CGFloat x1 = fPos.x + CONTROL_POINT_H * cos(b);
    CGFloat y1 = fPos.y + CONTROL_POINT_H * sin(b);
    CGFloat x2 = tPos.x + CONTROL_POINT_H * cos(b);
    CGFloat y2 = tPos.y + CONTROL_POINT_H * sin(b);
    
    return CGPointMake((x2 - x1) / 2 + x1, (y2 - y1) / 2 + y1);
}

- (CGPathRef)frogJumpPathFrom:(CGPoint)fPos to:(CGPoint)tPos {
    UIBezierPath *movePath = [UIBezierPath bezierPath];
    [movePath moveToPoint:CGPointMake(self.position.x, self.position.y)];
    [movePath addQuadCurveToPoint:tPos controlPoint:[self controlPointFrom:fPos to:tPos]];
    
    return movePath.CGPath;
}

- (BOOL)isJumpCompletion {
    return self.curLocationIndex == self.targetLocationIndex;
}

- (void)jump {
    if (!self.isJumping) {
        self.isJumping = YES;
        
        if ([self isJumpCompletion]) {
            self.isJumping = NO;
        }
        else {
            NSInteger targetIndex = self.curLocationIndex + 1;
            if (targetIndex >= self.allJumpPositions.count) {
                self.isJumping = NO;
                
                return;
            }
            
            NSValue *value = self.allJumpPositions[targetIndex];
            CGPoint targetPosition = [UniversalUtil universaliPadPoint:value.CGPointValue
                                                           iPhonePoint:CGPOINT_NON
                                                               offsetX:-20
                                                               offsetY:0];
            targetPosition = CGPointMake(targetPosition.x, targetPosition.y + self.size.height / 2 + [UniversalUtil universalDelta:20]);
            
            SKAction *moveAction = [SKAction followPath:[self frogJumpPathFrom:self.position to:targetPosition]
                                               asOffset:NO
                                           orientToPath:NO
                                               duration:0.5];
            [self runAction:moveAction completion:^{
                self.isJumping = NO;
                self.curLocationIndex++;
            }];
        }
    }
}

#pragma mark - Property
- (NSMutableArray *)allJumpPositions {
    if (!_allJumpPositions) {
        _allJumpPositions = [NSMutableArray array];
    }
    
    return _allJumpPositions;
}

@end
