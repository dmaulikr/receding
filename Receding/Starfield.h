//
//  Starfield.h
//  Receding
//
//  Created by matte on 10/15/14.
//  Copyright (c) 2014 MXTTE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "GameModel.h"

@interface Starfield : SKSpriteNode

-(void)loadStars:(int)starCount timeScale:(int)timeScale;

@end
