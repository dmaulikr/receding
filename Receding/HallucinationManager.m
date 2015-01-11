//
//  HallucinationManager.m
//  Receding
//
//  Created by matte on 10/16/14.
//  Copyright (c) 2014 MXTTE. All rights reserved.
//

#import "HallucinationManager.h"
#import "Hallucination.h"

@implementation HallucinationManager

+ (id)shared
{
    // Singleton
    static HallucinationManager *hallucinationManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        hallucinationManager = [self new];
    });
    
    
    return hallucinationManager;
}

- (id)init
{
    if (self = [super init]) {
    }
    return self;
}

-(void)startManager:(SKScene *)scene {
    self.scene = scene;
    if ([[GameModel shared] firstRun]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hallucinateReceived:)
                                                     name:@"Hallucinate" object:nil];
        [[GameModel shared] setFirstRun:NO];
    }
}

-(void)stopManager {
    [[NSNotificationCenter defaultCenter] removeObserver:@"Hallucinate"];
    self.scene = nil;
}


-(void)hallucinateReceived:(NSNotification*)notification
{
    [self hallucination:[[GameModel shared] randomHalluType]];
}

-(void)hallucination:(Class)class {
    Hallucination *hallucination = [[class alloc] init];
    [hallucination load];
//    [[GameModel shared] setCurrentHallucination:hallucination];
    [[GameModel shared] setCurrentHalluType:hallucination.name];
    [[GameModel shared] setCurrentGesture:hallucination.gestureRec];
    [self.scene addChild:hallucination];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:@"Hallucinate"];
}

@end
