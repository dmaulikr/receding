//
//  Starfield.m
//  Receding
//
//  Created by matte on 10/15/14.
//  Copyright (c) 2014 MXTTE. All rights reserved.
//

#import "Starfield.h"
//#import "GameHeaders.h"

@interface Starfield() {
    CGPoint centerPoint;
}
@end
    
@implementation Starfield

-(id)init {
    if (self = [super init]) {
        self.userInteractionEnabled = NO;
        self.position = UIScreen.mainScreen.bounds.origin;
        self.size = UIScreen.mainScreen.bounds.size;
        centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    }
    return self;
}

-(void)loadStars:(int)starCount timeScale:(int)timeScale {
    // Fix this
    [self stars:starCount timeScale:timeScale];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self stars:starCount timeScale:timeScale];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self stars:starCount timeScale:timeScale];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self stars:starCount timeScale:timeScale];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self stars:starCount timeScale:timeScale];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self stars:starCount timeScale:timeScale];
                    });
                });
            });
        });
    });
}

-(void)stars:(int)starCount timeScale:(int)timeScale {
    for (int i = 0; i < starCount; i++) {
        [self addChild:[self star:timeScale + (timeScale/4)]];
        [self addChild:[self star:timeScale]];
        [self addChild:[self star:timeScale - (timeScale/4)]];
        [self addChild:[self star:timeScale / 2]];
    }
}

-(SKSpriteNode *)star:(int)duration {
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"star"];
    sprite.userInteractionEnabled = NO;
    
    sprite.position = [[GameModel shared] randomPoint];
    NSArray *actionsArray = @[[SKAction moveTo:centerPoint duration:duration], [SKAction fadeAlphaTo:0 duration:duration - 1], [SKAction scaleTo:0 duration:duration]];

    SKAction *scaleAction = actionsArray[2];
    scaleAction.timingMode = SKActionTimingEaseOut;
    
    [sprite runAction:scaleAction];
    [sprite runAction:actionsArray[0] completion:^(void){
        [sprite removeFromParent];
        [self addChild:[self star:duration]];
    }];
    return sprite;
}

@end
