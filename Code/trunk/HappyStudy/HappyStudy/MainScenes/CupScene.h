//
//  CupScene.h
//  EasyLSP
//
//  Created by Q on 15/6/3.
//  Copyright (c) 2015年 LittleIsland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@class CupScene;

@protocol CupSceneDelegate <NSObject>

- (void)cupScene:(CupScene *)cupScene didClickExchange:(Task *)task;

@end

@interface CupScene : UIView

@property (weak, nonatomic) id<CupSceneDelegate> delegate;

+ (instancetype)sceneFromNib;

- (void)showInView:(UIView *)view;
- (void)dismiss;
- (void)reloadInfos;

- (BOOL)isShowing;

@end
