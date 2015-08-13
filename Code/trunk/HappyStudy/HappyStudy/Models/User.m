//
//  User.m
//  HappyStudy
//
//  Created by Q on 14-10-14.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)init {
    if (self = [super init]) {
        
    }
    
    return self;
}

#pragma mark - Property
- (void)setPlayTime:(double)playTime {
    if (!self.name) {
        return;
    }
    
    NSMutableDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kPROPERTY_USER_INFO];
    if (!userInfo) {
        userInfo = [NSMutableDictionary dictionary];
    }
    
    NSMutableDictionary *propertyInfo = userInfo[self.name];
    if (!propertyInfo) {
        propertyInfo = [NSMutableDictionary dictionary];
    }
    
    propertyInfo[kPROPERTY_PLAY_TIME] = @(playTime);
    userInfo[self.name] = propertyInfo;
    
    [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:kPROPERTY_USER_INFO];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (double)playTime {
    if (!self.name) {
        return 0.0;
    }
    
    NSMutableDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kPROPERTY_USER_INFO];
    
    return [userInfo[self.name][kPROPERTY_USER_INFO] doubleValue];
}

@end
