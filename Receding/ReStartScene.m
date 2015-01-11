//
//  ReStartScene.m
//  Receding
//
//  Created by matte on 11/9/14.
//  Copyright (c) 2014 MXTTE. All rights reserved.
//

#import "ReStartScene.h"
#import "GameModel.h"
#import "HallucinationManager.h"

@interface ReStartScene()

@property SKSpriteNode *vertNode;
@property SKSpriteNode *horizNode;
@property SKSpriteNode *retryNode;

@property UITapGestureRecognizer *tapGesture;

@property (nonatomic, retain) AVAudioPlayer *audioPlayer;

@property NSArray *retryTextArray;

@end

@implementation ReStartScene

-(void)didMoveToView:(SKView *)view {
    if (self.tapGesture) {
        [self.view removeGestureRecognizer:self.tapGesture];
    }
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(handleTap:)];
    
    NSURL *pingURL = [[NSURL alloc] initFileURLWithPath:
                      [[NSBundle mainBundle] pathForResource:@"start" ofType:@"wav"]];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:pingURL error:nil];
    [self.audioPlayer setDelegate:self];
    [self.audioPlayer prepareToPlay];

    self.retryTextArray = @[@"retry", @"maybe", @"perhaps"];
    self.backgroundColor = [UIColor blackColor];
    [self removeAllChildren];
    [self removeAllActions];
    
    int duration = [[GameModel shared] timeScale];
    
    int retryIndex = arc4random_uniform((int)self.retryTextArray.count);
    self.retryNode = [[SKSpriteNode alloc] initWithImageNamed:self.retryTextArray[retryIndex]];
    
    if ([[GameModel shared] firstRun]) {
        self.retryNode = [[SKSpriteNode alloc] initWithImageNamed:@"relax"];
    }
    self.retryNode.position = [[GameModel shared] getCenterPoint];
    [self scoring:self.retryNode];
    
    self.vertNode = [[SKSpriteNode alloc] initWithImageNamed:@"vert"];
    self.horizNode = [[SKSpriteNode alloc] initWithImageNamed:@"horiz"];


    self.retryNode.xScale = self.retryNode.yScale = 0.8;
    self.vertNode.xScale = self.vertNode.yScale = self.horizNode.xScale = self.horizNode.yScale = 1.5;
    self.retryNode.alpha = self.vertNode.alpha = self.horizNode.alpha = 0;
    self.vertNode.position = self.horizNode.position = [[GameModel shared] getCenterPoint];
    [self addChild:self.retryNode];
    [self addChild:self.vertNode];
    [self addChild:self.horizNode];
    SKAction *fadeIn = [SKAction fadeInWithDuration:duration/9];
    fadeIn.timingMode = SKActionTimingEaseInEaseOut;
    
    [[GameModel shared] reset];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration/12 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.horizNode runAction:fadeIn];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration/12 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.vertNode runAction:fadeIn];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration/9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.retryNode runAction:fadeIn];
                SKAction *scaleInOut = [SKAction scaleBy:0.5 duration:duration*2];
                scaleInOut.timingMode = SKActionTimingEaseInEaseOut;

                [self.vertNode runAction:scaleInOut completion:^(void){
                    [self.vertNode runAction:scaleInOut.reversedAction completion:^(void){
                        [self.vertNode runAction:scaleInOut completion:^(void){
                            [self.vertNode runAction:scaleInOut.reversedAction completion:^(void){
                                [self.vertNode runAction:scaleInOut completion:^(void){
                                    [self.vertNode runAction:scaleInOut.reversedAction completion:^(void){}];
                                }];
                            }];
                        }];
                    }];
                }];
                [self.horizNode runAction:scaleInOut.reversedAction completion:^(void){
                    [self.horizNode runAction:scaleInOut completion:^(void){
                        [self.horizNode runAction:scaleInOut.reversedAction completion:^(void){
                            [self.horizNode runAction:scaleInOut completion:^(void){
                                [self.horizNode runAction:scaleInOut.reversedAction completion:^(void){
                                    [self.horizNode runAction:scaleInOut completion:^(void){
                                    }];
                                }];
                            }];
                        }];
                    }];
                }];
            });
        });
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view addGestureRecognizer:self.tapGesture];
    });
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    [self.audioPlayer play];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.audioPlayer = nil;
    });
    [self.horizNode runAction:[SKAction scaleTo:0 duration:0.4]];
    [self.horizNode runAction:[SKAction fadeAlphaTo:0 duration:0.2]];
    
    [self.vertNode runAction:[SKAction scaleTo:0 duration:0.3]];
    [self.vertNode runAction:[SKAction fadeAlphaTo:0 duration:0.2]];

    [self.retryNode runAction:[SKAction scaleTo:5 duration:0.5]];
    [self.retryNode runAction:[SKAction fadeAlphaTo:0 duration:0.2] completion:^(void){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Restart" object:nil userInfo:nil];
    }];
}

- (void)scoring:(SKSpriteNode *)titlesNode {
    int score = [[GameModel shared] timeElapsed];
    if (![[GameModel shared] firstRun] && score > 0) {
        NSMutableArray *scoreStringArray = [[NSMutableArray alloc] init];
        scoreStringArray = [self scoreString:score scoreStringArray:scoreStringArray];
        SKSpriteNode *scoreNode = [SKSpriteNode node];
        scoreNode.position = CGPointMake(0, + 100);
        for (NSString *scoreDigit in scoreStringArray) {
            SKSpriteNode *digitNode = [[SKSpriteNode alloc] initWithImageNamed:scoreDigit];
            digitNode.position = CGPointMake((fabsf(scoreNode.position.x) + 10), digitNode.position.y + arc4random_uniform(2));
            scoreNode.position = CGPointMake(scoreNode.position.x - digitNode.size.width, scoreNode.position.y);
            [scoreNode addChild:digitNode];
        }
        scoreNode.position = CGPointMake(scoreNode.position.x / 2, scoreNode.position.y);
        [titlesNode addChild:scoreNode];
        titlesNode.position = CGPointMake([[GameModel shared] getCenterPoint].x, [[GameModel shared] getCenterPoint].y - (titlesNode.size.height/2));
    }
}

- (NSMutableArray *)scoreString:(float)score scoreStringArray:(NSMutableArray *)scoreStringArray {
    int currentDigit = 0;
    if (score >= 10) {
        score = score / 10;
        currentDigit = round((score - floor(score)) * 10);
        NSString *scoreString = [NSString stringWithFormat:@"%d", currentDigit];
        [scoreStringArray addObject:scoreString];
        [self scoreString:score scoreStringArray:scoreStringArray];
    } else {
        currentDigit = score;
        NSString *scoreString = [NSString stringWithFormat:@"%d", currentDigit];
        [scoreStringArray addObject:scoreString];
    }
    scoreStringArray = (NSMutableArray *)[[scoreStringArray reverseObjectEnumerator] allObjects];
    return scoreStringArray;
}

@end
