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

#pragma mark - Initialisation

+ (id)routeWithFeatureSet:(AGSFeatureSet*)featureSet startingPoint:(AGSPoint*)startingPoint
{
	return [[OGGameRoute alloc] initWithFeatureSet:featureSet startingPoint:startingPoint];
}

- (id)initWithFeatureSet:(AGSFeatureSet*)featureSet startingPoint:(AGSPoint*)startingPoint
{
    self = [super init];
	
    if (self)
	{
		self.tasks = [NSArray arrayWithArray:[self createTasksFromFeatureSet:featureSet startingPoint:startingPoint]];
		
		self.name = [featureSet.features[0] attributeAsStringForKey:kRouteNameField];
		self.routeID = [featureSet.features[0] attributeAsStringForKey:kRouteIDField];
    }
    
	return self;
}

#pragma mark - Public methods

- (void)unlockNextTask
{
	self.currentTaskIndex++;
	
	if (self.currentTaskIndex == 1)
	{
		self.startDate = [NSDate date];
	}
	
	if (self.currentTaskIndex > 0 && self.currentTaskIndex < self.tasks.count)
	{
		self.gameState = OGGameStateRunning;
	}
	else if (self.currentTaskIndex >= self.tasks.count)
	{
		self.gameState = OGGameStateFinished;
	}
}

#pragma mark - Private metods

- (NSArray*)createTasksFromFeatureSet:(AGSFeatureSet*)featureSet startingPoint:(AGSPoint*)startingPoint
{
	AGSGraphic *firstFeature = featureSet.features[0];
	
	OGTask *startTask = [OGTask taskWithAGSGraphic:firstFeature];
	startTask = [OGTask taskWithAGSGraphic:firstFeature];
	startTask.startPoint = startingPoint;
	startTask.destinationPoint = firstFeature.geometry.envelope.center;
	startTask.taskDescription = @"Finde den Startpunkt und begib dich dorthin";
	
	NSMutableArray *tmpTasks = [NSMutableArray arrayWithObject:startTask];
	
	[featureSet.features enumerateObjectsUsingBlock:^(AGSGraphic *feature, NSUInteger index, BOOL *stop)
	 {
		 OGTask *task = [OGTask taskWithAGSGraphic:feature];
		 
		 AGSGraphic *featureStart = featureSet.features[index];
		 AGSGraphic *featureDestination = featureSet.features[index + 1];
		 task = [OGTask taskWithAGSGraphic:featureStart];
		 task.waypointNumber = index;
		 task.destinationPoint = featureDestination.geometry.envelope.center;
		 task.taskDescription = [featureStart attributeAsStringForKey:kDescriptionField];
		 
		 [tmpTasks addObject:task];
		 
		 if (index == featureSet.features.count - 2)
		 {
			 *stop = YES;
		 }
	 }];
	
	return tmpTasks;
}


#pragma mark - Accessors

- (OGTask *)currentTask
{
	return self[self.currentTaskIndex];
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
