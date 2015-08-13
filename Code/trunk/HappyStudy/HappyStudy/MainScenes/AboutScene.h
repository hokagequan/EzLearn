//
//  AboutScene.h
//  HappyStudy
//
//  Created by Quan on 14/11/4.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutScene : UIView

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

+ (AboutScene *)sceneFromNib;
- (void)showInView:(SKView *)view;

@end
