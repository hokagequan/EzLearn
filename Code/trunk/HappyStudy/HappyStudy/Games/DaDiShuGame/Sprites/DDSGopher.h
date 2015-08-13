//
//  DDSGopher.h
//  EasyLSP
//
//  Created by Q on 15/5/26.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "HSLabelSprite.h"

typedef enum {
    GopherStatNormal = 0,
    GopherStatSmile,
    GopherStatCry
}GopherStat;

@interface DDSGopher : SKCropNode

@property (nonatomic) CGSize size;

- (instancetype)initWithTexture:(SKTexture *)texture smileTexture:(SKTexture *)smileTexture cryTexture:(SKTexture *)cryTexture;
- (void)setCardText:(NSString *)text;
- (void)setStat:(GopherStat)stat;

- (void)showUp;
- (void)hideDown;
- (void)hideAndShowWithPosition:(CGPoint)position text:(NSString *)text completion:(void (^)(void))completion;
- (BOOL)isMoving;

@end
