//
//  SettingMgr.m
//  EasyLSP
//
//  Created by Q on 14/11/19.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "SettingMgr.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface SettingMgr ()

@property (strong, nonatomic) AVAudioPlayer *backgroundAudioPlayer;

@end

@implementation SettingMgr

+ (instancetype)sharedInstance {
    static SettingMgr *_sharedSettingMgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedSettingMgr = [[SettingMgr alloc] init];
    });
    
    return _sharedSettingMgr;
}

+ (id)getValueForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (void)setValue:(id)value withKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)startBackgroundMusicWithName:(NSString *)name
{
    if ([SettingMgr sharedInstance].bgMusicOff) {
        return;
    }
    
    if (_backgroundAudioPlayer) {
        [_backgroundAudioPlayer stop];
        _backgroundAudioPlayer = nil;
    }
    
    NSError *err;
    NSURL *file = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:name ofType:nil]];
    _backgroundAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:file error:&err];
    if (err) {
        NSLog(@"error in audio play %@", [err userInfo]);
        return;
    }
    [_backgroundAudioPlayer prepareToPlay];
    
    // this will play the music infinitely
    _backgroundAudioPlayer.numberOfLoops = -1;
    [_backgroundAudioPlayer setVolume:0.2];
    [_backgroundAudioPlayer play];
}

- (void)stopBackgroundMusic {
    [_backgroundAudioPlayer stop];
    _backgroundAudioPlayer = nil;
}

#pragma mark - Property
- (void)setBgMusicOff:(BOOL)bgMusicOff {
    [SettingMgr setValue:@(bgMusicOff) withKey:@"BackgroundMusic"];
}

- (BOOL)bgMusicOff {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"BackgroundMusic"] boolValue];
}

@end
