//
//  Cannon.h
//  EasyLSP
//
//  Created by Quan on 15/5/12.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import "HSCharacter.h"

@interface Cannon : HSCharacter

@property (nonatomic) BOOL wantFire;

- (void)faceToLocation:(CGPoint)location;
- (void)fire;
- (void)rotateLeft;
- (void)rotateRight;

@end
