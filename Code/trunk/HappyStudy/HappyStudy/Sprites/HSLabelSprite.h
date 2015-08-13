//
//  HSLabelSprite.h
//  HappyStudy
//
//  Created by Quan on 14/10/26.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface HSLabelSprite : SKSpriteNode

@property (strong, nonatomic) SKLabelNode *label;

- (id)initWithTexture:(SKTexture *)texture title:(NSString *)title;

@end
