//
//  HSLabelSprite.m
//  HappyStudy
//
//  Created by Quan on 14/10/26.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "HSLabelSprite.h"

@implementation HSLabelSprite
@synthesize name = _name;

- (id)initWithTexture:(SKTexture *)texture title:(NSString *)title {
    if (self = [super initWithTexture:texture]) {
        _label = [[SKLabelNode alloc] initWithFontNamed:FONT_NAME_CUTOON];
        _label.fontSize = [UniversalUtil universalFontSize:60.];
        _label.text = title;
        _label.position = CGPointMake(_label.position.x, _label.position.y - [UniversalUtil universalDelta:10]);
        _label.zPosition = self.zPosition + 1;
        _label.userInteractionEnabled = NO;
        [self addChild:_label];
    }
    
    return self;
}

- (void)setName:(NSString *)name {
    [super setName:name];
    _name = name;
    self.label.name = name;
}

- (void)setZPosition:(CGFloat)zPosition {
    [super setZPosition:zPosition];
    self.label.zPosition = zPosition + 1;
}

#pragma mark - Property
- (SKLabelNode *)label {
    if (!_label) {
        _label = [[SKLabelNode alloc] initWithFontNamed:FONT_NAME_CUTOON];
        _label.fontSize = [UniversalUtil universalFontSize:60.];
        _label.position = CGPointMake(_label.position.x, _label.position.y - [UniversalUtil universalDelta:10]);
        _label.zPosition = self.zPosition + 1;
        _label.userInteractionEnabled = NO;
        [self addChild:_label];
    }
    
    return _label;
}

@end
