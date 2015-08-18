//
//  InfoScene.h
//  EasyLSP
//
//  Created by Q on 15/8/18.
//  Copyright © 2015年 LittleIsland. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoScene : UIView

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

+ (InfoScene *)sceneFromNib;
- (void)showInView:(SKView *)view;

@end
