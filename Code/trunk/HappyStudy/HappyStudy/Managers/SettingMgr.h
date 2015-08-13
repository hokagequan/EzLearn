//
//  SettingMgr.h
//  EasyLSP
//
//  Created by Q on 14/11/19.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KEY_SCHOOL_ID @"KEY_SCHOOL_ID"

@interface SettingMgr : NSObject

@property (nonatomic) BOOL bgMusicOff;

+ (instancetype)sharedInstance;
+ (void)setValue:(id)value withKey:(NSString *)key;
+ (id)getValueForKey:(NSString *)key;

- (void)startBackgroundMusicWithName:(NSString *)name;
- (void)stopBackgroundMusic;

@end
