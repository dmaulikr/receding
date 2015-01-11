//
//  GameViewController.m
//  Receding
//
//  Created by matte on 10/13/14.
//  Copyright (c) 2014 MXTTE. All rights reserved.
//

#import "GameViewController.h"
#import "GameModel.h"

#import "GameScene.h"
#import "ReStartScene.h"

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    skView.ignoresSiblingOrder = NO;
    ReStartScene *scene = [ReStartScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [skView presentScene:scene];

    [[NSNotificationCenter defaultCenter] removeObserver:@"GameOver"];
    [[NSNotificationCenter defaultCenter] removeObserver:@"Restart"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameoverReceived:)
                                                 name:@"GameOver" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restartReceived:)
                                                 name:@"Restart" object:nil];
}

-(void)gameoverReceived:(NSNotification*)notification
{
    ReStartScene *scene = [ReStartScene sceneWithSize:self.view.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    self.scene = scene;
    [scene removeAllChildren];
    SKTransition *fadeTrans = [SKTransition fadeWithColor:[[GameModel shared] badColor]duration:1];
    [(SKView *)self.view presentScene:scene transition:fadeTrans];
}

-(void)restartReceived:(NSNotification *)notification
{
    GameScene *scene = [GameScene sceneWithSize:self.view.bounds.size];
    self.scene = scene;
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [scene removeAllChildren];
    SKTransition *fadeTrans = [SKTransition fadeWithColor:[[GameModel shared] goodColor] duration:1];
    [[NSNotificationCenter defaultCenter] removeObserver:@"PointLost"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pointLost:)
                                                 name:@"PointLost" object:nil];
    [(SKView *)self.view presentScene:scene transition:fadeTrans];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)pointLost:(NSNotification *)notification {
    self.scene.backgroundColor = [UIColor blackColor];
    self.scene.backgroundColor = [[GameModel shared] badColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.scene.backgroundColor = [UIColor blackColor];
    });
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:@"Restart"];
    [[NSNotificationCenter defaultCenter] removeObserver:@"GameOver"];
}

@end
