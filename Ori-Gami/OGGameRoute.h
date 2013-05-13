//
//  OGRoute.h
//  Ori-Gami
//
//  Created by Benni on 16.03.13.
//  Copyright (c) 2013 Ifgi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OGRoute.h"

@class OGTask;
@class AGSFeatureSet;
@class AGSPoint;


typedef enum
{
	OGGameStateStarting,
	OGGameStateRunning,
	OGGameStateFinished
} OGGameState;

@interface OGGameRoute : OGRoute

@property (nonatomic, strong, readonly) OGTask *currentTask;
@property (nonatomic, readonly) OGGameState gameState;
@property (nonatomic, readonly) NSTimeInterval time;

+ (id)routeWithFeatureSet:(AGSFeatureSet*)featureSet startingPoint:(AGSPoint*)startingPoint;
- (id)initWithFeatureSet:(AGSFeatureSet*)featureSet startingPoint:(AGSPoint*)startingPoint;
- (void)unlockNextTask;


@end
