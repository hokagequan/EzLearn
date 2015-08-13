//
//  User.h
//  HappyStudy
//
//  Created by Q on 14-10-14.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *name;
@property (nonatomic) Group group;
@property (nonatomic) NSInteger score;
@property (nonatomic) double playTime; // 秒

@end
