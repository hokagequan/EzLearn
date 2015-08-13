//
//  GameSelectViewController.m
//  HappyStudy
//
//  Created by Q on 14-10-14.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "GameSelectViewController.h"
#import "GameViewController.h"
#import "GameMgr.h"

@interface GameSelectViewController ()

@end

@implementation GameSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)enterGameWorld {
    [self performSegueWithIdentifier:@"pushGameSceneSegue" sender:nil];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - Actions
- (IBAction)clickGameChoose:(id)sender {
    [GameMgr sharedInstance].selGame = StudyGameChoose;
    [self enterGameWorld];
}

- (IBAction)clickGameDuiDuiPeng:(id)sender {
    [GameMgr sharedInstance].selGame = StudyGameDuiDuiPeng;
    [self enterGameWorld];
}

@end
