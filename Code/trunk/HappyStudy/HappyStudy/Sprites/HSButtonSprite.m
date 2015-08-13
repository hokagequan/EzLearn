//
//  HSButtonSprite.m
//  HappyStudy
//
//  Created by Q on 14/11/3.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "HSButtonSprite.h"

@interface HSButtonSprite ()

@property (strong, nonatomic) NSString *norImage;
@property (strong, nonatomic) NSString *selImage;

@property (strong, nonatomic) SKTexture *norTexture;
@property (strong, nonatomic) SKTexture *selTexture;

@end

@implementation HSButtonSprite

- (id)initWithTitle:(NSString *)title norImage:(NSString *)norImage selImage:(NSString *)selImage {
    SKTexture *texture = [SKTexture textureWithImageNamed:norImage];
    if (self = [super initWithTexture:texture title:title]) {
        self.norImage = norImage;
        self.selImage = selImage;
    }
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)title norTexture:(SKTexture *)norTexture selTexture:(SKTexture *)selTexture {
    if (self = [super initWithTexture:norTexture title:title]) {
        self.norTexture = norTexture;
        self.selTexture = selTexture;
    }
    
    return self;
}

// MARK: Property
- (void)setSelected:(BOOL)selected {
    _selected = selected;
    
    if (self.selImage && self.norImage) {
        NSString *imageName = selected ? self.selImage : self.norImage;
        SKTexture *texture = [SKTexture textureWithImageNamed:imageName];
        self.texture = texture;
    }
    if (self.selTexture && self.norTexture) {
        SKTexture *texture = selected ? self.selTexture : self.norTexture;
        self.texture = texture;
    }
}

@end
