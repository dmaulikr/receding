//
//  Hallucination.h
//  Receding
//
//  Created by matte on 10/14/14.
//  Copyright (c) 2014 MXTTE. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>
#import "GameModel.h"

@interface Hallucination : SKSpriteNode <SKPhysicsContactDelegate, AVAudioPlayerDelegate>

@property (nonatomic, retain) NSArray *planeTextures;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (nonatomic, retain) AVAudioPlayer *exitPlayer;
@property (nonatomic, retain) NSArray *soundEntryURLS;
@property (nonatomic, retain) NSArray *soundExitURLS;

@property (nonatomic, retain) SKTexture *texture1;
@property (nonatomic, retain) SKTexture *texture2;
@property (nonatomic, retain) SKTexture *texture3;

@property (nonatomic, retain) SKSpriteNode *backNode;
@property (nonatomic, retain) SKSpriteNode *middleNode;
@property (nonatomic, retain) SKSpriteNode *frontNode;

@property (nonatomic, retain) NSString *gestureRec;
@property BOOL actionLock;

@property (nonatomic, retain) SKAction *scaleAction;
@property float duration;

- (void)load;
- (void)handleInteraction:(NSDictionary *)interactionData;
- (void)positionAndRun;
- (void)setupAudioPlayer;
- (void)exitAudioPlayer;
- (void)failAudioPlayer;
- (void)loseIt;
- (void)recede;

- (void)idleAnimation;

@end
