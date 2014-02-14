//
//  StartScene.m
//  ShieldsActive
//
//  Created by Adam Jacaruso on 2/8/14.
//  Copyright (c) 2014 Adam Jacaruso. All rights reserved.
//

#import "StartScene.h"
#import "MyScene.h"

@implementation StartScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
        label.text = @"Shields Active!";
        label.fontSize = 40;
        label.fontColor = [SKColor whiteColor];
        label.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:label];
        
        SKSpriteNode *startButton = [SKSpriteNode spriteNodeWithImageNamed:@"Start"];
        startButton.position = CGPointMake(self.size.width/2, self.size.height/2 - startButton.size.height);
        startButton.name = @"StartButton";
        [self addChild: startButton];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    //Action for the StartButton Button
    if ([node.name isEqualToString:@"StartButton"]) {
        SKTransition *transition = [SKTransition fadeWithDuration:0.3];
        SKScene * myScene = [[MyScene alloc] initWithSize: self.size];
        [self.view presentScene:myScene transition: transition];
    }
}
@end
