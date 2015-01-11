//
//  HPyra.m
//  Receding
//
//  Created by matte on 10/14/14.
//  Copyright (c) 2014 MXTTE. All rights reserved.
//

#import "HSKull.h"

@implementation HSKull

- (id)init
{
    if (self = [super init]) {
    }
    return self;
}

- (void)load {
    [super load];
    self.gestureRec = @"tap";
    self.name = @"SKull";
    
    self.texture1 = [SKTexture textureWithImageNamed:@"skircle1"];
    self.texture2 = [SKTexture textureWithImageNamed:@"skcross1"];
    self.texture3 = [SKTexture textureWithImageNamed:@"skull1"];
    [SKTexture preloadTextures:@[self.texture1, self.texture2, self.texture3] withCompletionHandler:^(void){
        [self positionAndRun];
    }];
}


-(void)positionAndRun {
    [super positionAndRun];
    [self removeAllActions];
    
    self.backNode = [[SKSpriteNode node] initWithTexture:self.texture1];
    self.middleNode = [[SKSpriteNode node] initWithTexture:self.texture2];
    self.frontNode = [[SKSpriteNode node] initWithTexture:self.texture3];
    
    self.position = [[GameModel shared] getCenterPoint];
    self.alpha = 0;
    self.xScale = self.yScale = 1;
    self.duration = [[GameModel shared] timeScale];
    
    self.middleNode.xScale = self.middleNode.yScale = 2;
    self.backNode.xScale = self.backNode.yScale = 1;
    self.frontNode.xScale = self.frontNode.yScale = 1;
    self.frontNode.name = self.name;
    self.middleNode.name = self.name;
    self.backNode.name = self.name;
    self.middleNode.alpha = 0.5;

    [self addChild:self.backNode];
    [self addChild:self.middleNode];
    [self addChild:self.frontNode];
    
    [self runAction:[SKAction moveTo:[[GameModel shared] getCenterPoint] duration:self.duration]];
    [self.backNode runAction:[SKAction rotateByAngle:-5 duration:self.duration]];
    [self.middleNode runAction:[SKAction rotateByAngle:5 duration:self.duration]];
    [self idleAnimation];
    [self recede];
    [self runAction:[SKAction fadeAlphaTo:1 duration:self.duration/8] completion:^(void){
        [self.audioPlayer play];
        [self.frontNode runAction:[SKAction fadeAlphaTo:1 duration:self.duration/8] completion:^(void){
        }];
    }];
}

-(void)handleInteraction:(NSDictionary *)interactionData {
    if (!self.actionLock) {
        self.actionLock = YES;
        [self exitAudioPlayer];
        [self removeAllActions];
        [self runAction:[SKAction fadeOutWithDuration:0.5]];
        [self runAction:[SKAction scaleTo:(self.xScale * 2) duration:0.1] completion:^(void){
            [self.exitPlayer play];
            [self runAction:[SKAction moveTo:[[GameModel shared] getCenterPoint] duration:0.2]];
            [self runAction:[SKAction scaleTo:0.25 duration:0.2
                             ] completion:^(void){
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
        }];
    }
}

- (void)idleAnimation {
    SKAction *zoomIn = [SKAction scaleTo:1.1 duration:0.5];
    SKAction *zoomOut = [SKAction scaleTo:0.9 duration:0.75];
    zoomIn.timingMode = zoomOut.timingMode = SKActionTimingEaseInEaseOut;
    [self.frontNode runAction:zoomIn completion:^(void){
        [self.frontNode runAction:zoomOut completion:^(void){
            [self idleAnimation];
        }];
    }];
}

- (void)recede {
    [super recede];
    [self runAction:self.scaleAction];
    //    [self.frontNode runAction:self.scaleAction];
    //    [self.middleNode runAction:self.scaleAction];
    //    [self.backNode runAction:self.scaleAction];
}

@end
