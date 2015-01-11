//
//  GameScene.m
//  Receding
//
//  Created by matte on 10/13/14.
//  Copyright (c) 2014 MXTTE. All rights reserved.
//

#import "GameScene.h"
#import "GameManager.h"
#import "HallucinationManager.h"

#import "Hallucination.h"
#import "Starfield.h"

@interface GameScene() {
    CGPoint centerPoint;
    int starTimeScale;
    int starCount;
    Starfield *starField;
}
@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    [self removeAllChildren];
    [self removeAllActions];
    [[GameModel shared] restart];
    
    starTimeScale = 5;
    starCount = 5;
    
    centerPoint = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    self.backgroundColor = [UIColor blackColor];
    
    [self starField];
    
    [[HallucinationManager shared] startManager:self];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]];
    [self.view addGestureRecognizer:[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotate:)]];
    UISwipeGestureRecognizer *swipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleUDSwipe:)];
    [swipeUpRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.view addGestureRecognizer:swipeUpRecognizer];
    UISwipeGestureRecognizer *swipeDownRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleUDSwipe:)];
    [swipeDownRecognizer setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:swipeDownRecognizer];
    UISwipeGestureRecognizer *swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleLRSwipe:)];
    [swipeRightRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRightRecognizer];
    UISwipeGestureRecognizer *swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleLRSwipe:)];
    [swipeLeftRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeLeftRecognizer];
    [self.view addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)]];
}

-(void)gameManager {
    [[GameManager shared] load:self];
}

-(void)starField {
    starField = [[Starfield alloc] init];
    [starField loadStars:starCount timeScale:starTimeScale];
    [self addChild:starField];
}

- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer {
    if ([[[GameModel shared] currentGesture] isEqualToString:@"pinch"]) {
        [self passGesture:recognizer];
    } else {
        [self wrongGesture];
    }
}

- (void)handleUDSwipe:(UISwipeGestureRecognizer *)recognizer {
    if ([[[GameModel shared] currentGesture] isEqualToString:@"swipeUD"]) {
        [self passGesture:recognizer];
    } else {
        [self wrongGesture];
    }
}

- (void)handleLRSwipe:(UISwipeGestureRecognizer *)recognizer {
    if ([[[GameModel shared] currentGesture] isEqualToString:@"swipeLR"]) {
        [self passGesture:recognizer];
    } else {
        [self wrongGesture];
    }
}

- (void)handleRotate:(UIRotationGestureRecognizer *)recognizer {
    if ([[[GameModel shared] currentGesture] isEqualToString:@"rotate"]) {
        [self passGesture:recognizer];
    } else {
        [self wrongGesture];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    if ([[[GameModel shared] currentGesture] isEqualToString:@"tap"]) {
        [self passGesture:recognizer];
    } else {
        [self wrongGesture];
    }
}

- (void)passGesture:(UIGestureRecognizer *)recognizer {
    CGPoint touchLocation = [recognizer locationInView:recognizer.view];
    touchLocation = [self convertPointFromView:touchLocation];
    if ([[self nodeAtPoint:touchLocation].name isEqualToString:[[GameModel shared] currentHalluType]]) {
        if ([[self nodeAtPoint:touchLocation].parent respondsToSelector:@selector(handleInteraction:)]) {
            Hallucination *touchedNode = (Hallucination *)[[self nodeAtPoint:touchLocation] parent];
            NSDictionary *interactionData = @{@"type" : @"touch", @"recognizer" : recognizer, @"" : @""};
            [touchedNode handleInteraction:interactionData];
        } else if ([[self nodeAtPoint:touchLocation].parent.parent respondsToSelector:@selector(handleInteraction:)]) {
            Hallucination *touchedNode = (Hallucination *)[[[self nodeAtPoint:touchLocation] parent] parent];
            NSDictionary *interactionData = @{@"type" : @"touch", @"recognizer" : recognizer, @"" : @""};
            [touchedNode handleInteraction:interactionData];
        }
    } else {
        
        [self wrongGesture];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
}

-(void)update:(CFTimeInterval)currentTime {
}

- (void)wrongGesture {
    self.backgroundColor = [UIColor blackColor];
    self.backgroundColor = [UIColor grayColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.backgroundColor = [UIColor blackColor];
    });
}
@end
