//
//  InfoScene.m
//  EasyLSP
//
//  Created by Q on 15/8/18.
//  Copyright © 2015年 LittleIsland. All rights reserved.
//

#import "InfoScene.h"

@interface InfoScene()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelHeightLV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewTopLC;
@property (weak, nonatomic) SKView *parentView;
@property (weak, nonatomic) IBOutlet UIButton *dontShowButton;

@end

@implementation InfoScene

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (InfoScene *)sceneFromNib {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"InfoScene"
                                                   owner:nil
                                                 options:nil];
    for (UIView *view in views) {
        if ([view isKindOfClass:[InfoScene class]]) {
            InfoScene *scene = (InfoScene *)view;
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:scene.textView.text attributes:@{NSFontAttributeName: [UIFont fontWithName:FONT_NAME_HP size:[UniversalUtil universalFontSize:22]], NSForegroundColorAttributeName: colorRGB(180, 100, 50, 1)}];
            NSRange parentRange = [scene.textView.text rangeOfString:@"Parent"];
            NSRange schoolRange = [scene.textView.text rangeOfString:@"School"];
            [text addAttributes:@{NSFontAttributeName: [UIFont fontWithName:FONT_NAME_HP size:[UniversalUtil universalFontSize:36]]} range:parentRange];
            [text addAttributes:@{NSFontAttributeName: [UIFont fontWithName:FONT_NAME_HP size:[UniversalUtil universalFontSize:36]]} range:schoolRange];
            scene.textView.attributedText = text;
//            scene.textView.font = [UIFont fontWithName:FONT_NAME_HP size:[UniversalUtil universalFontSize:17]];
//            scene.textView.textColor = colorRGB(180, 100, 50, 1);
            scene.textView.dataDetectorTypes = UIDataDetectorTypeLink;
            scene.textView.selectable = YES;
            scene.textView.linkTextAttributes = @{NSForegroundColorAttributeName: colorRGB(180, 100, 50, 1),
                                                  NSUnderlineStyleAttributeName: @(1)};
//            scene.titleLabel.font = [UIFont fontWithName:FONT_NAME_HP size:[UniversalUtil universalFontSize:36]];
            scene.titleLabelHeightLV.constant = [UniversalUtil universalDelta:43];
            scene.textViewTopLC.constant = [UniversalUtil universalDelta:-20];
            scene.backgroundImageView.image = [UIImage imageNamed:@"about_bg"];
            [scene.closeButton setImage:[UIImage imageNamed:@"about_close"]
                               forState:UIControlStateNormal];
            
            scene.dontShowButton.titleLabel.font = [UIFont fontWithName:FONT_NAME_HP size:[UniversalUtil universalFontSize:24]];
            
            return scene;
        }
    }
    
    return nil;
}

- (void)showInView:(SKView *)view {
    self.parentView = view;
    self.parentView.scene.userInteractionEnabled = NO;
    
    CGRect frame = self.frame;
    frame.origin = CGPointMake(0,0);
    frame.size = view.bounds.size;
    self.frame = frame;
    
    [view addSubview:self];
    [view bringSubviewToFront:self];
}

- (IBAction)clickClose:(id)sender {
    self.parentView.scene.userInteractionEnabled = YES;
    [self removeFromSuperview];
}

- (IBAction)clickDontShow:(id)sender {
    self.dontShowButton.selected = !self.dontShowButton.selected;
    [SettingMgr setValue:@(self.dontShowButton.selected) withKey:KEY_HIDE_INFO];
}

@end
