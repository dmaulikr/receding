//
//  GameManager.m
//  Receding
//
//  Created by matte on 10/16/14.
//  Copyright (c) 2014 MXTTE. All rights reserved.
//

#import "GameManager.h"
#import "GameModel.h"

@implementation GameManager

+ (id)shared
{
    // Singleton
    static GameManager *gameManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gameManager = [self new];
    });
    return gameManager;
}

- (id)init
{
    if (self = [super init]) {
        // init gameModel
        [GameModel shared];
    }
    return self;
}

- (void)load:(SKScene *)scene {
}

- (void)updateSanity:(int)sanityChange {
    [[GameModel shared] updateSanity:sanityChange];
}

- (void)gameOver {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GameOver" object:nil userInfo:nil];
}

- (void)restart {
}

@end
