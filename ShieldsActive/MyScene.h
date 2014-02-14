//
//  MyScene.h
//  ShieldsActive
//

//  Copyright (c) 2014 Adam Jacaruso. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MyScene : SKScene <SKPhysicsContactDelegate>

@property (nonatomic) SKSpriteNode * shield;
@property (nonatomic) SKLabelNode * scoreLabel;
@property (nonatomic) SKLabelNode * lifeLabel;
@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) int Life;
@property (nonatomic) int Score;

@end
