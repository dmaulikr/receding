//
//  GameManager.h
//  Receding
//
//  Created by matte on 10/16/14.
//  Copyright (c) 2014 MXTTE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import <GameKit/GameKit.h>

@interface GameManager : NSObject

+ (id)shared;
- (void)load:(SKScene *)scene;
- (void)updateSanity:(int)sanityChange;

- (void)gameOver;
- (void)restart;

@end
