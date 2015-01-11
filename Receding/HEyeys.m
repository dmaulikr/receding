//
//  HEyeys.m
//  Receding
//
//  Created by matte on 10/14/14.
//  Copyright (c) 2014 MXTTE. All rights reserved.
//

#import "HEyeys.h"

@interface HEyeys()

@property BOOL actionLock;

@end

@implementation HEyeys

- (id)init
{
    if (self = [super init]) {
    }
    return self;
}

- (void)load {
    [super load];
    self.gestureRec = @"rotate";
    self.name = @"Eyeys";
    self.xScale = self.yScale = 1.25;
    
    self.texture1 = [SKTexture textureWithImageNamed:@"circles2"];
    self.texture2 = [SKTexture textureWithImageNamed:@"eyes1"];
    self.texture3 = nil;
    [SKTexture preloadTextures:@[self.texture1, self.texture2] withCompletionHandler:^(void){
        [self positionAndRun];
    }];
}


-(void)positionAndRun {
    [super positionAndRun];
    [self removeAllActions];
    self.position = [[GameModel shared] getCenterPoint];
    self.xScale = self.yScale = 1;
    self.alpha = 0;
    
    self.duration = [[GameModel shared] timeScale];
    SKAction *scaleAction = [SKAction scaleTo:0.25 duration:self.duration];
    scaleAction.timingMode = SKActionTimingEaseOut;
    self.backNode = [[SKSpriteNode node] initWithTexture:self.texture1];
    self.middleNode = [[SKSpriteNode node] initWithTexture:self.texture2];
//    self.frontNode = [[SKSpriteNode node] initWithTexture:self.texture1];
    self.backNode.xScale = self.backNode.yScale = 2;
    self.backNode.name = self.name;
    self.middleNode.name = self.name;
//    self.frontNode.name = self.name;
    self.middleNode.xScale = self.middleNode.yScale = 1;
//    self.frontNode.xScale = self.frontNode.yScale = 1;

    [self addChild:self.backNode];
    [self addChild:self.middleNode];
//    [self addChild:self.frontNode];

    [self runAction:[SKAction moveTo:[[GameModel shared] getCenterPoint] duration:self.duration]];
    [self.backNode runAction:[SKAction rotateByAngle:-20 duration:self.duration]];
//    [self.frontNode runAction:[SKAction rotateByAngle:20 duration:self.duration]];
    [self recede];
    [self idleAnimation];
    [self runAction:[SKAction fadeAlphaTo:1 duration:self.duration/8] completion:^(void){
        [self.audioPlayer play];
    }];
}

-(void)handleInteraction:(NSDictionary *)interactionData {
    if (!self.actionLock) {
        self.actionLock = YES;
        [self exitAudioPlayer];
        [self removeAllActions];
        UIRotationGestureRecognizer *recognizer = [interactionData objectForKey:@"recognizer"];
        [self runAction:[SKAction rotateByAngle:(recognizer.rotation * -100) duration:1]];
        [self.middleNode removeAllActions];
        [self.exitPlayer play];
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

- (void)idleAnimation {
    SKAction *rockForward = [SKAction rotateToAngle:0.5 duration:0.5];
    rockForward.timingMode = SKActionTimingEaseInEaseOut;
    SKAction *rockBackward = [SKAction rotateToAngle:-0.5 duration:0.5];
    rockBackward.timingMode = SKActionTimingEaseInEaseOut;
    [self.middleNode runAction:rockForward completion:^(void){
        [self.middleNode runAction:rockBackward completion:^(void){
            [self idleAnimation];
        }];
    }];
}

- (void)recede {
    [super recede];
    [self.frontNode runAction:self.scaleAction];
    [self.middleNode runAction:self.scaleAction];
    [self.backNode runAction:self.scaleAction];
}

@end
