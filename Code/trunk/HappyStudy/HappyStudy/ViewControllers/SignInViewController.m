//
//  SignInViewController.m
//  HappyStudy
//
//  Created by Q on 14-10-14.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "SignInViewController.h"
#import "GameSelectViewController.h"

@interface SignInViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UIButton *signInBtn;

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.signInBtn.titleLabel.font = [UIFont fontWithName:@"FZKaTong-M19S" size:17.];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

#pragma mark - Actions
- (IBAction)clickSignIn:(id)sender {
    // FIXME: 服务器交互是否登录成功
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < 1200; i++) {
            NSLog(@"*****Counting: %d", i);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"pushGameSelectSeg" sender:nil];
        });
    });
}

@end
