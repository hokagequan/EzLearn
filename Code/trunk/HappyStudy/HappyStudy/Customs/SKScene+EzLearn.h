//
//  SKScene+EzLearn.h
//  EasyLSP
//
//  Created by Q on 15/7/10.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKScene (EzLearn)

- (void)spawnStarsZPosition:(NSInteger)zPosition;
- (void)showCorrectCongratulations:(CGPoint)position completion:(void (^)())completion;

@end
