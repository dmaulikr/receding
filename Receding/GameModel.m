//
//  GameModel.m
//  Receding
//
//  Created by matte on 10/15/14.
//  Copyright (c) 2014 MXTTE. All rights reserved.
//
#import "GameModel.h"
#import "GameManager.h"
#import "Hallucination.h"
#import "HFlower1.h"
#import "HJester.h"
#import "HJoker.h"
#import "HEyeys.h"
#import "HPyra.h"
#import "HGateI.h"
#import "HSKull.h"
#import "HSymbols.h"
#import "HSwords.h"

@implementation GameModel

+ (id)shared
{
    // Singleton
    static GameModel *gameModel = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        gameModel = [self new];
    });
    
    return gameModel;
}

- (id)init
{
    if (self = [super init]) {
        self.hallucinationTypes = @[[HSwords class], [HPyra class], [HJoker class],
                                    [HSymbols class], [HSKull class], [HJester class],
                                    [HFlower1 class], [HGateI class], [HGateI class],
                                    [HFlower1 class], [HGateI class], [HEyeys class]];
        self.firstRun = YES;
        [self reset];
    }
    

    return self;
}

- (void)reset {
    self.tier = 2;
    self.timeInterval = 1.0;
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.badColor = [UIColor colorWithRed:1 green:0.1 blue:0.25 alpha:1];
    self.goodColor = [UIColor cyanColor];
    //    self.badColor = [UIColor magentaColor];
    //    self.badColor = [UIColor whiteColor];
    self.timeScale = 2.5;
    self.timeElapsed = 0;
    self.score = 0;
    self.sanity = 5;
    self.centerPoint = CGPointMake(UIScreen.mainScreen.bounds.size.width/2, UIScreen.mainScreen.bounds.size.height/2);
    self.currentHalluType = nil;
    self.currentGesture = nil;
//    self.currentHallucination = nil;
}

- (void)restart {
    [self timerInit];
}

- (void)loadFromDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.timeElapsed = [[defaults valueForKey:@"timeElapsed"] intValue];
    self.sanity = [[defaults valueForKey:@"sanity"] intValue];
}

- (void)set:(id)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)getValueForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}


-(void)timerInit {
    self.timer = nil;
    self.timer = [NSTimer timerWithTimeInterval:self.timeInterval target:self selector:@selector(timerUpdate:) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:@"NSDefaultRunLoopMode"];
}


-(void)timerUpdate:(NSTimer *)timer {
    self.timeElapsed += 1;
    self.timer = [NSTimer timerWithTimeInterval:self.timeInterval target:self selector:@selector(timerUpdate:) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:@"NSDefaultRunLoopMode"];
    if (fmod(self.timeElapsed, 2) == 0) {
        //  speed up!
        self.timeInterval *= 0.99;
        // create hallucination
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Hallucinate" object:nil userInfo:nil];
    }
    if (fmod(self.timeElapsed, 5) == 0 && self.tier < self.hallucinationTypes.count) {
        // tier up!
        self.tier += 1;
    }
}

-(void)updateSanity:(int)sanityChange {
    self.sanity += sanityChange;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PointLost" object:nil userInfo:nil];
    [self gameOverCheck];
}

-(void)gameOverCheck {
    if (self.sanity <= 0) {
        [[GameManager shared] gameOver];
    }
}

-(CGPoint)randomPoint {
    CGPoint centerPoint = CGPointMake(UIScreen.mainScreen.bounds.size.width/2, UIScreen.mainScreen.bounds.size.height/2);
    float randomX = arc4random_uniform(UIScreen.mainScreen.bounds.size.width);
    float randomY = arc4random_uniform(UIScreen.mainScreen.bounds.size.height);
    int threeSidedCoin = floor(arc4random_uniform(3));
                              
    if (threeSidedCoin == 2) {
        if (randomX < centerPoint.x) {
            randomX -= centerPoint.x;
        } else {
            randomX += centerPoint.x;
        }
    } else if (threeSidedCoin == 1) {
        if (randomY < centerPoint.y) {
            randomY -= centerPoint.y;
        } else {
            randomY += centerPoint.y;
        }
    } else {
        if (randomX < centerPoint.x) {
            randomX -= centerPoint.x;
        } else {
            randomX += centerPoint.x;
        }
        if (randomY < centerPoint.y) {
            randomY -= centerPoint.y;
        } else {
            randomY += centerPoint.y;
        }
    }
  return CGPointMake(randomX, randomY);
}

- (CGPoint)getCenterPoint {
    return self.centerPoint;
}

- (void)updateCenterPoint:(CGPoint)newCenterPoint {
    self.centerPoint = newCenterPoint;
}


- (Class)randomHalluType {
    int hallucinationIndex = arc4random_uniform(self.tier);
    return (Class)[self.hallucinationTypes objectAtIndex:hallucinationIndex];
}
@end
