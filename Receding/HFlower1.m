//
//  HFlower.m
//  Receding
//
//  Created by matte on 10/14/14.
//  Copyright (c) 2014 MXTTE. All rights reserved.
//

#import "HFlower1.h"

@interface HFlower1()

@property NSArray *flowerImages;

@property BOOL actionLock;

@end

@implementation HFlower1

- (id)init
{
    if (self = [super init]) {
        self.flowerImages = @[@"flower1", @"flower2"];
    }
    return self;
}

- (void)load {
    [super load];
    self.gestureRec = @"rotate";
    self.name = @"Flower";
    self.xScale = self.yScale = 1.25;
    
    int flowerIndex = arc4random_uniform((int)self.flowerImages.count);
    self.texture1 = [SKTexture textureWithImageNamed:@"circles2"];
    self.texture2 = [SKTexture textureWithImageNamed:self.flowerImages[flowerIndex]];
    self.texture3 = nil;
    [SKTexture preloadTextures:@[self.texture1, self.texture2] withCompletionHandler:^(void){
        [self positionAndRun];
    }];
    
}


-(void)positionAndRun {
    [super positionAndRun];
    [self removeAllActions];
    
    self.alpha = 0;

    self.backNode = [[SKSpriteNode node] initWithTexture:self.texture1];
    self.middleNode = [[SKSpriteNode node] initWithTexture:self.texture2];
    
    SKSpriteNode *flowerNode =  [[SKSpriteNode node] initWithTexture:self.texture2];
    SKSpriteNode *flowerNode2 = [[SKSpriteNode node] initWithTexture:self.texture2];
    SKSpriteNode *flowerNode3 = [[SKSpriteNode node] initWithTexture:self.texture2];

    [self.middleNode addChild:flowerNode];
    [self.middleNode addChild:flowerNode2];
    [self.middleNode addChild:flowerNode3];

    flowerNode.name = flowerNode2.name = flowerNode3.name = self.name;
    flowerNode.xScale = flowerNode.yScale = 0.75;
    flowerNode2.xScale = flowerNode2.yScale = 0.5;
    flowerNode3.xScale = flowerNode3.yScale = 0.25;
    self.middleNode.name = self.name;
    self.middleNode.xScale = self.middleNode.yScale = 2;
    self.backNode.xScale = self.backNode.yScale = 2;
    self.backNode.name = self.name;
    self.middleNode.alpha = self.frontNode.alpha = 0;

    [self addChild:self.backNode];
    [self addChild:self.middleNode];
    
    [flowerNode runAction:[SKAction rotateByAngle:-1 duration:self.duration]];
    [flowerNode2 runAction:[SKAction rotateByAngle:1 duration:self.duration]];
    [flowerNode3 runAction:[SKAction rotateByAngle:-1.25 duration:self.duration]];
    [self.backNode runAction:[SKAction rotateByAngle:-2 duration:self.duration]];
    [self.backNode runAction:self.scaleAction];
    [self.middleNode runAction:self.scaleAction];
    [self recede];
    [self runAction:[SKAction fadeAlphaTo:1 duration:self.duration/8] completion:^(void){
        [self.audioPlayer play];
        [self.middleNode runAction:[SKAction fadeAlphaTo:1 duration:self.duration/8] completion:^(void){
        }];
    }];
}

-(void)handleInteraction:(NSDictionary *)interactionData {
    if (!self.actionLock) {
        self.actionLock = YES;
        [self exitAudioPlayer];
        UIRotationGestureRecognizer *recognizer = [interactionData objectForKey:@"recognizer"];
        [self removeAllActions];
        [self.exitPlayer play];
        [self runAction:[SKAction rotateByAngle:(recognizer.rotation * -100) duration:1]];
        [self runAction:[SKAction fadeOutWithDuration:0.5] completion:^(void){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.exitPlayer = nil;
                self.audioPlayer = nil;
            });
            
            [self removeAllChildren];
            self.texture1 = nil;
            self.texture2 = nil;
            self.texture3 = nil;
            [self removeFromParent];
        }];
    }
}

- (void)recede {
    [super recede];
    [self.middleNode runAction:[SKAction rotateByAngle:3 duration:self.duration]];
}

- (void)idleAnimation {
}

@end
