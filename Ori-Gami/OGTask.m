//
//  OGTask.m
//  Ori-Gami
//
//  Created by Benni on 11.03.13.
//  Copyright (c) 2013 Ifgi. All rights reserved.
//

#import "OGTask.h"

@implementation OGTask

/**
 Convinience method for creating a new task object from an AGSGraphic object, which is returned from feature layer selections.
 **/
+ (instancetype)taskWithAGSGraphic:(AGSGraphic*)graphic
{
	OGTask *task = [[OGTask alloc] init];
	task.startPoint = graphic.geometry.envelope.center;
	task.waypointNumber = 0;
	
	return task;
}

/**
 Calculates the distance from the given point to the destination point.
 **/
- (CGFloat)distanceToDestinationFromPoint:(AGSPoint *)point
{
	return [point distanceToPoint:self.destinationPoint];
}

/**
 Calculates the distance from the start point to the destination point.
 **/
- (CGFloat)distanceToDestinationFromStartPoint
{
	return [self distanceToDestinationFromPoint:self.startPoint];
}

/**
 Returns a niceley readable version of the task
 **/
- (NSString *)description
{
	return [NSString stringWithFormat:@"Waypoint: %i\n%1.0f - %1.0f\nTask: %@\n------------------------------------------------------------------------------------------------------------------", self.waypointNumber, self.destinationPoint.x, self.destinationPoint.y, self.taskDescription];
}

@end
