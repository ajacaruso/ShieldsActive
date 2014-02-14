//
//  EndScene.m
//  ShieldsActive
//
//  Created by Adam Jacaruso on 2/7/14.
//  Copyright (c) 2014 Adam Jacaruso. All rights reserved.
//

#import "EndScene.h"
#import "MyScene.h"

@implementation EndScene

//Creating a custome initWithSize to take in if a user has won or lost
-(id)initWithSize:(CGSize)size userHasWon:(BOOL)userHasWon {

    if (self = [super initWithSize:size]) {
        
        NSString * gameEndText;
        if (userHasWon) {
            gameEndText = @"You Win!";
        } else {
            gameEndText = @"You’ve Lost.";
        }
        
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
        label.text = gameEndText;
        label.fontSize = 40;
        label.fontColor = [SKColor whiteColor];
        label.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:label];
        
        SKSpriteNode *playAgain = [SKSpriteNode spriteNodeWithImageNamed:@"PlayAgain"];
        playAgain.position = CGPointMake(self.size.width/2, self.size.height/2 - playAgain.size.height);
        playAgain.name = @"playAgain";
        [self addChild: playAgain];
        
        
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    //Action for the playAgain Button
    if ([node.name isEqualToString:@"playAgain"]) {
        SKTransition *transition = [SKTransition fadeWithDuration:0.3];
        SKScene * myScene = [[MyScene alloc] initWithSize: self.size];
        [self.view presentScene:myScene transition: transition];
    }
    
}

@end
