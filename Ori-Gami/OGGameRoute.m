//
//  OGRoute.m
//  Ori-Gami
//
//  Created by Benni on 16.03.13.
//  Copyright (c) 2013 Ifgi. All rights reserved.
//

#import "OGGameRoute.h"
#import "OGTask.h"
#import <ArcGIS/ArcGIS.h>

@interface OGGameRoute () <AGSQueryTaskDelegate>

@property (nonatomic, assign) NSInteger currentTaskIndex;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) RouteCompletionBlock completion;

@property (nonatomic, strong) AGSQuery *query;
@property (nonatomic, strong) AGSQueryTask *queryTask;

@end

@implementation OGGameRoute


#pragma mark - Public methods

- (void)unlockNextTask
{
	self.currentTaskIndex++;
	
	if (self.currentTaskIndex == 1)
	{
		self.startDate = [NSDate date];
	}
	
	if (self.currentTaskIndex > 0 && self.currentTaskIndex < _tasks.count)
	{
		self.gameState = OGGameStateRunning;
	}
	else if (self.currentTaskIndex >= _tasks.count)
	{
		self.gameState = OGGameStateFinished;
	}
}

- (void)setStartingPoint:(AGSPoint *)startingPoint
{
	
}


#pragma mark - Accessors

- (OGTask *)currentTask
{
	return _tasks[self.currentTaskIndex];
}

- (void)setGameState:(OGGameState)gameState
{
	_gameState = gameState;
}

- (NSTimeInterval)time
{
	return [[NSDate date] timeIntervalSinceDate:self.startDate];
}


@end
