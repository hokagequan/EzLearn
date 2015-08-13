//
//  ZMKBasket.h
//  EasyLSP
//
//  Created by Q on 15/7/23.
//  Copyright © 2015年 LittleIsland. All rights reserved.
//

#import "HSLabelSprite.h"

@interface ZMKBasket : HSLabelSprite

- (void)addFruit:(HSLabelSprite *)fruit;
- (void)removeSingleFruit;
- (void)clean;

@end
