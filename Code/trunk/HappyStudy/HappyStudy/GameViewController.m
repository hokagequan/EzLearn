//
//  GameViewController.m
//  HappyStudy
//
//  Created by Q on 14-10-11.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "GameViewController.h"
#import "SignInScene.h"
#import "VersionSeletionScene.h"
#import "LoadingScene.h"
#import "GameSelectScene.h"

//#import "ZiMuBaoGameScene.h"

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
//    // Create and configure the scene.
//    GameScene *scene = [GameScene unarchiveFromFile:@"GameScene"];
//    scene.scaleMode = SKSceneScaleModeAspectFill;
//    
//    // Present the scene.
//    [skView presentScene:scene];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handlePresentNofication:)
                                                 name:kNOTIFICATION_GAME_PRESENT_VIEW_CONTROLLER
                                               object:nil];
    
//    SignInScene *scene = [[SignInScene alloc] initWithSize:self.view.bounds.size];
//    scene.scaleMode = SKSceneScaleModeAspectFill;
//    
//    LoadingScene *loadingScene = [[LoadingScene alloc] initWithSize:scene.size];
//    loadingScene.isFake = YES;
//    loadingScene.presentScene = scene;
//    [(SKView *)self.view presentScene:loadingScene];
//    [GameSelectScene loadAssets];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kNOTIFICATION_GAME_PRESENT_VIEW_CONTROLLER
                                                  object:nil];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    VersionSeletionScene *scene = [[VersionSeletionScene alloc] initWithSize:self.view.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    LoadingScene *loadingScene = [[LoadingScene alloc] initWithSize:scene.size];
    loadingScene.isFake = YES;
    loadingScene.presentScene = scene;
    [(SKView *)self.view presentScene:loadingScene];
    [GameSelectScene loadAssets];
}

//- (void)viewWillLayoutSubviews
//{
//    [super viewWillLayoutSubviews];
//    
//    // Configure the view.
//    SKView * skView = (SKView *)self.view;
//    if (!skView.scene) {
//        skView.showsFPS = YES;
//        skView.showsNodeCount = YES;
//        /* Sprite Kit applies additional optimizations to improve rendering performance */
//        skView.ignoresSiblingOrder = YES;
//        
//        SignInScene *scene = [[SignInScene alloc] initWithSize:self.view.bounds.size];
//        scene.scaleMode = SKSceneScaleModeAspectFill;
//        
//        LoadingScene *loadingScene = [[LoadingScene alloc] initWithSize:scene.size];
//        loadingScene.isFake = YES;
//        loadingScene.presentScene = scene;
//        [(SKView *)self.view presentScene:loadingScene];
//        [GameSelectScene loadAssets];
//    }
//}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskLandscape;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Notification
- (void)handlePresentNofication:(NSNotification *)notification {
    if (!notification.object) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"请设置账户"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    UIViewController *vc = notification.object;
    [self presentViewController:vc animated:YES completion:nil];
}

@end
