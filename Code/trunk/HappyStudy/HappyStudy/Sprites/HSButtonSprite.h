//
//  HSButtonSprite.h
//  HappyStudy
//
//  Created by Q on 14/11/3.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "HSLabelSprite.h"

@interface HSButtonSprite : HSLabelSprite

@property (nonatomic) BOOL selected;

- (id)initWithTitle:(NSString *)title norImage:(NSString *)norImage selImage:(NSString *)selImage;
- (id)initWithTitle:(NSString *)title norTexture:(SKTexture *)norTexture selTexture:(SKTexture *)selTexture;

@end
