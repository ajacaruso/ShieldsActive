//
//  ViewController.m
//  ShieldsActive
//
//  Created by Adam Jacaruso on 2/5/14.
//  Copyright (c) 2014 Adam Jacaruso. All rights reserved.
//

#import "ViewController.h"
#import "StartScene.h"

@implementation ViewController

// viewWillLayoutSubviews instead of viewDidLoad
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    SKScene * scene = [StartScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    [skView presentScene:scene];
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
    // Release any cached data, images, etc that aren't in use.
}

@end
