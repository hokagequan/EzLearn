//
//  GameViewController.h
//  HappyStudy
//

//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <iAd/iAd.h>

@interface GameViewController : UIViewController<ADBannerViewDelegate>

@property (weak, nonatomic) IBOutlet ADBannerView *bannerView;

@end
