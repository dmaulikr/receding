//
//  HGateI.m
//  Receding
//
//  Created by matte on 10/14/14.
//  Copyright (c) 2014 MXTTE. All rights reserved.
//

#import "HGateI.h"

@interface HGateI()

@property NSArray *gateImages;
@property BOOL exiting;
@property NSMutableArray *leftGates;
@property NSMutableArray *rightGates;
@property NSMutableArray *gateBlocks;
@property BOOL actionLock;

@end

@implementation HGateI

- (id)init
{
    if (self = [super init]) {
        self.exiting = NO;
        NSArray *tempArray = @[@[@"gate1r", @"gate1l"], @[@"gate2r", @"gate2l"],
                            @[@"gate3r", @"gate3l"], @[@"gate4r", @"gate4l"],
                            @[@"gate5r", @"gate5l"]];
        int gateIndex = arc4random_uniform((int)tempArray.count);
        self.scaleAction = [SKAction scaleTo:0 duration:self.duration];
        self.gateImages = tempArray[gateIndex];
        self.gateBlocks = [[NSMutableArray alloc] init];
        self.rightGates = [[NSMutableArray alloc] init];
        self.leftGates = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)load {
    [super load];
    self.gestureRec = @"pinch";
    self.name = @"Gate I";
    
    self.texture1 = [SKTexture textureWithImageNamed:@"gateBlock"];
    self.texture2 = [SKTexture textureWithImageNamed:self.gateImages[0]];
    self.texture3 = [SKTexture textureWithImageNamed:self.gateImages[1]];
    [SKTexture preloadTextures:@[self.texture1, self.texture2, self.texture3] withCompletionHandler:^(void){
        [self positionAndRun];
    }];
}


-(void)positionAndRun {
    [super positionAndRun];
    self.xScale = self.yScale = 2;
    
    self.alpha = 0;

    for (int i = 6; i > 0; i--) {
        self.scaleAction = [SKAction scaleTo:0 duration:self.duration + (i/2)];
        SKSpriteNode *iterationNode = [SKSpriteNode node];
        SKSpriteNode *backNode = [[SKSpriteNode node] initWithTexture:self.texture1];
        backNode.xScale = backNode.yScale = 1;
        backNode.alpha = 0;
        [backNode runAction:[SKAction fadeAlphaTo:0.2 duration:self.duration/8]];
        backNode.name = self.name;
        [self.gateBlocks addObject:backNode];
        [iterationNode addChild:backNode];
        
        SKSpriteNode *middleNode = [[SKSpriteNode node] initWithTexture:self.texture2];
        middleNode.alpha = 0;
        middleNode.name = self.name;
        [middleNode runAction:[SKAction fadeInWithDuration:self.duration/8] completion:^(void){
            
        }];
        middleNode.xScale = middleNode.yScale = 1;
        [self.rightGates addObject:middleNode];
        [iterationNode addChild:middleNode];
        
        SKSpriteNode *frontNode = [[SKSpriteNode node] initWithTexture:self.texture3];
        frontNode.alpha = 0;
        frontNode.name = self.name;
        [frontNode runAction:[SKAction fadeAlphaTo:1.0 duration:self.duration/8]];
        frontNode.xScale = frontNode.yScale = 1;
        [self.leftGates addObject:frontNode];
        [iterationNode addChild:frontNode];
        iterationNode.xScale = iterationNode.yScale = i;
        iterationNode.name = self.name;
        iterationNode.zPosition = i - 6;
        if (i <= 2) {
            [iterationNode runAction:self.scaleAction completion:^(void){
                [self loseIt];
            }];
        } else {
            [iterationNode runAction:self.scaleAction];
        }
        [self addChild:iterationNode];
    }
    [self idleAnimation];
//    [self recede];
    [self runAction:self.scaleAction];

    [self runAction:[SKAction fadeAlphaTo:1 duration:self.duration/8] completion:^(void){
        [self.audioPlayer play];
    }];
}

-(void)handleInteraction:(NSDictionary *)interactionData {
    if (!self.actionLock) {
        self.actionLock = YES;
        [self exitAudioPlayer];
        [self.exitPlayer play];
        [self removeAllActions];
        int moveBy = self.parent.scene.view.frame.size.width;
        UIPinchGestureRecognizer *recognizer = [interactionData objectForKey:@"recognizer"];
        if (recognizer.scale > 0) {
            self.exiting = YES;
            for (int i = 0; i < self.gateBlocks.count; i++) {
                    SKSpriteNode *backNode = self.gateBlocks[i];
                    SKSpriteNode *middleNode = self.rightGates[i];
                    SKSpriteNode *frontNode = self.leftGates[i];
                    [backNode removeAllActions];
                    [middleNode removeAllActions];
                    [frontNode removeAllActions];
                    backNode.alpha = 0;
                    [middleNode runAction:[SKAction moveTo:CGPointMake(self.middleNode.position.x + moveBy, self.middleNode.position.y) duration:0.5]];
                    [middleNode runAction:[SKAction scaleTo:0 duration:0.5]];
                    [frontNode runAction:[SKAction moveTo:CGPointMake(self.middleNode.position.x - moveBy, self.middleNode.position.y) duration:0.5]];
                    [frontNode runAction:[SKAction scaleTo:0 duration:0.5]];
            }
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
}

- (void)idleAnimation {
    for (int i = 0; i < self.gateBlocks.count; i++) {
        if (fmod(i, 2) == 0) {
            [self.gateBlocks[i] runAction:[SKAction fadeAlphaTo:0 duration:0.5] completion:^(void){
                if (!self.exiting) {
                    [self.gateBlocks[i] runAction:[SKAction fadeAlphaTo:0.25 duration:0.1] completion:^(void){
                        if (i == (self.gateBlocks.count - 1) && !self.exiting) {
                            [self idleAnimation];
                        }
                    }];
                }
            }];
        } else {
            [self.gateBlocks[i] runAction:[SKAction fadeAlphaTo:0.2 duration:0.5] completion:^(void){
                if (!self.exiting) {
                    [self.gateBlocks[i] runAction:[SKAction fadeAlphaTo:0 duration:0.1] completion:^(void){
                        if (i == (self.gateBlocks.count - 1) && !self.exiting) {
                            [self idleAnimation];
                        }
                    }];
                }
            }];
        }
    }
}

@end
