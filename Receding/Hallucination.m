//
//  Hallucination.m
//  Receding
//
//  Created by matte on 10/14/14.
//  Copyright (c) 2014 MXTTE. All rights reserved.
//

#import "Hallucination.h"

@implementation Hallucination 

- (id)init
{
    if (self = [super init]) {
    }
    return self;
}

- (void)load {
    [self setupAudioPlayer];
}

-(void)positionAndRun {
    [self removeAllActions];
    self.actionLock = NO;
    self.position = [[GameModel shared] getCenterPoint];
    self.xScale = self.yScale = 1;
    self.duration = [[GameModel shared] timeScale];
    [self runAction:[SKAction moveTo:[[GameModel shared] getCenterPoint] duration:self.duration]];
    self.scaleAction = [SKAction scaleTo:0.25 duration:self.duration];
    self.scaleAction.timingMode = SKActionTimingEaseOut;
}

-(void)handleInteraction:(NSDictionary *)interactionData {
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    
}

- (void)setupAudioPlayer {
    self.soundEntryURLS = @[[[NSURL alloc] initFileURLWithPath:
                            [[NSBundle mainBundle] pathForResource:@"pong1" ofType:@"wav"]],
                           [[NSURL alloc] initFileURLWithPath:
                            [[NSBundle mainBundle] pathForResource:@"pong2" ofType:@"wav"]],
                           [[NSURL alloc] initFileURLWithPath:
                            [[NSBundle mainBundle] pathForResource:@"pong3" ofType:@"wav"]],
                           [[NSURL alloc] initFileURLWithPath:
                            [[NSBundle mainBundle] pathForResource:@"pong4" ofType:@"wav"]],
                           [[NSURL alloc] initFileURLWithPath:
                            [[NSBundle mainBundle] pathForResource:@"pong5" ofType:@"wav"]],
                           [[NSURL alloc] initFileURLWithPath:
                            [[NSBundle mainBundle] pathForResource:@"pong6" ofType:@"wav"]]
                           ];
    int currentSound = arc4random_uniform((int)self.soundEntryURLS.count - 2) + 2;
//    int currentSound = arc4random_uniform(self.soundEntryURLS.count);
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.soundEntryURLS[currentSound] error:nil];
    [self.audioPlayer setDelegate:self];
    [self.audioPlayer prepareToPlay];
}

- (void)exitAudioPlayer {
    self.soundExitURLS = @[[[NSURL alloc] initFileURLWithPath:
                             [[NSBundle mainBundle] pathForResource:@"pang1" ofType:@"wav"]],
                            [[NSURL alloc] initFileURLWithPath:
                             [[NSBundle mainBundle] pathForResource:@"pang2" ofType:@"wav"]],
                           [[NSURL alloc] initFileURLWithPath:
                            [[NSBundle mainBundle] pathForResource:@"pang3" ofType:@"wav"]],
                           [[NSURL alloc] initFileURLWithPath:
                            [[NSBundle mainBundle] pathForResource:@"pang4" ofType:@"wav"]]
                            ];
    int currentSound = arc4random_uniform((int)self.soundExitURLS.count);
    self.exitPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.soundExitURLS[currentSound] error:nil];
    [self.exitPlayer setDelegate:self];
    [self.exitPlayer prepareToPlay];
}


- (void)failAudioPlayer {
    NSURL *pingURL = [[NSURL alloc] initFileURLWithPath:
                        [[NSBundle mainBundle] pathForResource:@"ping1" ofType:@"wav"]];
    self.exitPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:pingURL error:nil];
    [self.exitPlayer setDelegate:self];
    [self.exitPlayer prepareToPlay];
}

- (void)loseIt {
    [self failAudioPlayer];
    [[GameModel shared] updateSanity:-1];
    [self.exitPlayer play];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.exitPlayer = nil;
        self.audioPlayer = nil;
    });
    [self removeAllActions];
    [self removeAllChildren];
    self.texture1 = nil;
    self.texture2 = nil;
    self.texture3 = nil;
    [self removeFromParent];
}

- (void)recede {
    [self.middleNode runAction:self.scaleAction completion:^(void){
        [self loseIt];
    }];
}

- (void)idleAnimation {
}

@end
