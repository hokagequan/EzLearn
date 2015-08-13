//
//  CGQuestion.m
//  HappyStudy
//
//  Created by Q on 14-10-14.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "CGQuestion.h"
#import "GlobalUtil.h"

@interface CGQuestion ()

@end

@implementation CGQuestion

- (id)initWithString:(NSString *)string soundName:(NSString *)soundName position:(CGPoint)position {
    if (self = [super initWithTexture:nil title:string]) {
        self.position = position;
        self.soundName = soundName;
        
        self.label.fontSize = [UniversalUtil universalFontSize:60.];
        self.label.fontName = FONT_NAME_HP;
        self.label.fontColor = colorRGB(255, 170, 0, 1);
        self.label.position = CGPointMake(self.label.position.x, self.label.position.y + [UniversalUtil universalDelta:20.]);
    }
    
    return self;
}

- (void)playSound {
    if ([self actionForKey:@"PlaySound"]) {
        [self removeActionForKey:@"PlaySound"];
    }
    if (!self.soundName || ![GlobalUtil soundFileExist:self.soundName]) {
        return;
    }
    
    [self runAction:[SKAction playSoundFileNamed:self.soundName waitForCompletion:YES] withKey:@"PlaySound"];
}

@end
