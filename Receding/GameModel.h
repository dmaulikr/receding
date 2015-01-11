//
//  GameModel.h
//  Receding
//
//  Created by matte on 10/15/14.
//  Copyright (c) 2014 MXTTE. All rights reserved.
//

//#import "Hallucination.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreGraphics/CoreGraphics.h>
#import <SpriteKit/SpriteKit.h>

@interface GameModel : NSObject

@property int timeScale;
@property int timeElapsed;
@property float timeInterval;
@property int sanity;
@property int score;
@property CGPoint centerPoint;
@property NSArray *hallucinationTypes;
@property int tier;

//@property Hallucination *currentHallucination;
@property NSString *currentHalluType;
@property NSString *currentGesture;

@property (nonatomic, strong) NSTimer *timer;

@property UIColor *badColor;
@property UIColor *goodColor;

@property BOOL firstRun;



// ?
//@property CGPoint centerPoint;
// ?

+ (id)shared;
- (void)loadFromDefaults;
- (void)set:(id)value forKey:(NSString *)key;
- (void)reset;
- (void)restart;

- (void)updateSanity:(int)sanityChange;

- (CGPoint)randomPoint;
- (CGPoint)getCenterPoint;
- (void)updateCenterPoint:(CGPoint)newCenterPoint;

- (Class)randomHalluType;

@end
