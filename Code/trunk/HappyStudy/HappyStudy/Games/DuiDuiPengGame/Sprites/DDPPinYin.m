//
//  DDPPinYin.m
//  HappyStudy
//
//  Created by Quan on 14/10/22.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "DDPPinYin.h"
#import "GlobalUtil.h"

@interface DDPPinYin ()

@property (strong, nonatomic) NSString *soundName;

@end

@implementation DDPPinYin

- (id)initWithString:(NSString *)string soundName:(NSString *)soundName matchKey:(NSString *)matchKey position:(CGPoint)position {
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:[UniversalUtil universalAtlasName:@"Card_Yellow_Idle"]];
    SKTexture *norTexture = [atlas textureNamed:@"card_yellow_idle_0001"];
    SKTexture *selTexture = [atlas textureNamed:@"card_yellow_idle_0002"];
    if (self = [super initWithTitle:string norTexture:norTexture selTexture:selTexture]) {
        self.position = position;
        self.soundName = soundName;
        self.matchKey = matchKey;
    }
    
    return self;
}

#pragma mark - Override
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        SKAction *changeColor = [SKAction runBlock:^{
            self.label.fontColor = [self selectedColor];
        }];
        if (self.soundName && [GlobalUtil soundFileExist:self.soundName]) {
            SKAction *playSound = [SKAction playSoundFileNamed:self.soundName waitForCompletion:YES];
            SKAction *scale = [SKAction scaleTo:1.2 duration:0.2];
            [self runAction:[SKAction group:@[playSound, scale, changeColor]]];
        }
        else {
            SKAction *scale = [SKAction scaleTo:1.2 duration:0.2];
            [self runAction:[SKAction group:@[scale, changeColor]]];
        }
    }
    else {
        SKAction *changeColor = [SKAction runBlock:^{
            self.label.fontColor = [self normalColor];
        }];
        SKAction *scale = [SKAction scaleTo:1.0 duration:0.2];
        [self runAction:[SKAction group:@[scale, changeColor]]];
    }
}

- (UIColor *)normalColor {
    return [UIColor whiteColor];
}

- (UIColor *)selectedColor {
    return colorRGB(255, 240, 165, 1);
}

#pragma mark - Touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.requestedAnimation == HSAnimationStateDeath) {
        return;
    }
    
    DuiDuiPengGameScene *scene = [self characterScene];
    if (scene) {
        [scene clickCharacter:self];
    }
}

@end
