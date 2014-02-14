//
//  MyScene.m
//  ShieldsActive
//
//  Created by Adam Jacaruso on 2/5/14.
//  Copyright (c) 2014 Adam Jacaruso. All rights reserved.
//

#import "MyScene.h"
#import "EndScene.h"

@implementation MyScene

//Create Category for Colision Detection
static const uint32_t shieldCategory =  0x1 << 0;
static const uint32_t asteroidCategory =  0x1 << 1;

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        
        // Create Starting Shield
        self.shield = [SKSpriteNode spriteNodeWithImageNamed:@"Shield"];
        self.shield.position = CGPointMake(self.shield.size.width*2, self.frame.size.height/2);
        [self addChild:self.shield];
        
        //Init Object Physics On Shield
        self.shield.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.shield.size];
        self.shield.physicsBody.categoryBitMask = shieldCategory;
        self.shield.physicsBody.contactTestBitMask = asteroidCategory;
        self.shield.physicsBody.collisionBitMask = 0;
        
        //Create UI
        [self createUI];
        
        //Init Gravity - Changing 
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;
    }
    return self;
}

-(void)createUI {
    
    //Create Score UI
    self.Score = 0;
    self.scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
    self.scoreLabel.fontSize = 15;
    self.scoreLabel.fontColor = [SKColor whiteColor];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d / 10", self.Score];
    self.scoreLabel.position = CGPointMake(self.size.width - self.scoreLabel.frame.size.width/2 - 40, self.size.height - (40 + self.scoreLabel.frame.size.height/2));
    [self addChild:self.scoreLabel];
    
    //Create Life UI
    self.Life = 3;
    self.lifeLabel = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
    self.lifeLabel.fontSize = 15;
    self.lifeLabel.fontColor = [SKColor whiteColor];
    self.lifeLabel.text = [NSString stringWithFormat:@"Life: %d", self.Life];
    self.lifeLabel.position = CGPointMake(self.lifeLabel.frame.size.width/2 + 40, self.size.height - (40 + self.lifeLabel.frame.size.height/2));
    [self addChild:self.lifeLabel];
}

-(void)createAsteroid {
    
    SKSpriteNode * asteroid = [SKSpriteNode spriteNodeWithImageNamed:@"Asteroid"];
    
    //Create Random Start Location off the screen
    int minY = asteroid.size.height / 2;
    int maxY = self.frame.size.height - ((asteroid.size.height / 2) + 40 + self.scoreLabel.frame.size.height);
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    asteroid.position = CGPointMake(self.frame.size.width + asteroid.size.width/2, actualY);
    [self addChild:asteroid];
    
    //Set Velocity of the asteroid
    int minDuration = 1.0;
    int maxDuration = 3.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    SKAction * actionMove = [SKAction moveTo:CGPointMake(-asteroid.size.width/2, actualY) duration:actualDuration];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    [asteroid runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
    
    //Init Object Physics On Asteroids
    asteroid.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:asteroid.size];
    asteroid.physicsBody.categoryBitMask = asteroidCategory;
    asteroid.physicsBody.contactTestBitMask = shieldCategory;
    asteroid.physicsBody.collisionBitMask = 0;
    
    //Set Loss Condition - Tied to Asteroid Going off Screen
    SKAction * loseAction = [SKAction runBlock:^{
        self.Life -= 1;
        self.lifeLabel.text = [NSString stringWithFormat:@"Life: %d", self.Life];
        if (self.Life == 0) {
            SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
            SKScene * gameOverScene = [[EndScene alloc] initWithSize:self.size userHasWon:NO];
            [self.view presentScene:gameOverScene transition: reveal];
        }
    }];
    [asteroid runAction:[SKAction sequence:@[actionMove, loseAction, actionMoveDone]]];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // Move Shield To New Location
    for (UITouch *touch in touches) {
       CGPoint location = [touch locationInNode:self];
       self.shield.position = location;
    }
}

-(void)update:(CFTimeInterval)currentTime {
    
    //Stagger the Creation of Asteroids
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    self.lastSpawnTimeInterval += timeSinceLast;
    if (self.lastSpawnTimeInterval > 1) {
        self.lastSpawnTimeInterval = 0;
        [self createAsteroid];
    }
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody, *secondBody;
    
    //Detect which object is an Asteroid and Which is a Shield
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    } else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    //If an Asteroid Colides with a Sheild
    if ((firstBody.categoryBitMask & shieldCategory) != 0 && (secondBody.categoryBitMask & asteroidCategory) != 0){
        [self shield:(SKSpriteNode *) firstBody.node didCollideWithasteroid:(SKSpriteNode *) secondBody.node];
    }
}

- (void)shield:(SKSpriteNode *)shield didCollideWithasteroid:(SKSpriteNode *)asteroid {

    [asteroid removeFromParent];
    
    //Increase Score and Check for Win Condition
    self.Score += 1;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d / 10", self.Score];
    if (self.Score >= 10) {
        SKTransition *transition = [SKTransition fadeWithDuration:0.3];
        SKScene * gameOverScene = [[EndScene alloc] initWithSize:self.size userHasWon:YES];
        [self.view presentScene:gameOverScene transition: transition];
    }
}


@end
