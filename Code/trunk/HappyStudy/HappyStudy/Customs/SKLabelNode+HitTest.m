//
//  SKLabelNode+HitTest.m
//  HappyStudy
//
//  Created by Q on 14/11/10.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "SKLabelNode+HitTest.h"

@implementation SKLabelNode (HitTest)

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.parent) {
        [self.parent touchesBegan:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.parent) {
        [self.parent touchesMoved:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.parent) {
        [self.parent touchesEnded:touches withEvent:event];
    }
}

@end
