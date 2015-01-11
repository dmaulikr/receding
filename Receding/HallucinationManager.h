//
//  HallucinationManager.h
//  Receding
//
//  Created by matte on 10/16/14.
//  Copyright (c) 2014 MXTTE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface HallucinationManager : NSObject
@property (nonatomic, strong) SKScene *scene;

+ (id)shared;
- (void)startManager:(SKScene *)scene;
- (void)stopManager;

@end
