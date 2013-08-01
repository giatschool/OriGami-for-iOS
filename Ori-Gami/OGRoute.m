//
//  OGRoute.m
//  Ori-Gami
//
//  Created by Benni on 11.05.13.
//  Copyright (c) 2013 Ifgi. All rights reserved.
//

#import "OGRoute.h"
#import "OGTask.h"
#import <ArcGIS/ArcGIS.h>


@interface OGRoute () <AGSQueryTaskDelegate>

@property (nonatomic, strong) RouteCompletionBlock completion;

@property (nonatomic, strong) AGSQuery *query;
@property (nonatomic, strong) AGSQueryTask *queryTask;

@end

@implementation OGRoute


#pragma mark - Initialisation

+ (id)routeWithRouteID:(NSString*)routeID
{
	return [[self alloc] initWithRouteID:routeID];
}

- (id)initWithRouteID:(NSString*)routeID
{
    self = [super init];
	
    if (self)
	{		
		
    }
    
	return self;
}


+ (id)routeWithFeatureSet:(AGSFeatureSet*)featureSet
{
	return [[self alloc] initWithFeatureSet:featureSet];
}

- (id)initWithFeatureSet:(AGSFeatureSet*)featureSet
{
    self = [super init];
	
    if (self)
	{
		_tasks = [NSArray arrayWithArray:[self createTasksFromFeatureSet:featureSet]];
		
		self.name = [featureSet.features[0] attributeAsStringForKey:kRouteNameField];
		self.routeID = [featureSet.features[0] attributeAsStringForKey:kRouteIDField];
    }
    
	return self;
}



#pragma mark - Public methods

- (void)queryAllRoutes:(RouteCompletionBlock)completion
{
	self.completion = completion;
	
	self.query = [AGSQuery query];
	self.query.outFields = [NSArray arrayWithObjects:kRouteIDField, nil];
	self.query.orderByFields = @[[NSString stringWithFormat:@"%@ ASC", kRouteIDField]];
	self.query.where = [NSString stringWithFormat:@"%@ IS NOT NULL", kRouteIDField];
	
	self.queryTask = [AGSQueryTask queryTaskWithURL:[NSURL URLWithString:kFeatureLayerURLGame]];
	self.queryTask.delegate = self;
	[self.queryTask executeWithQuery:self.query];
}

- (void)queryRouteWithID:(NSString*)routeID completion:(RouteCompletionBlock)completion
{
	self.completion = completion;
	
	self.query = [AGSQuery query];
	self.query.outFields = [NSArray arrayWithObjects:kRouteIDField, nil];
	self.query.orderByFields = @[[NSString stringWithFormat:@"%@ ASC", kRouteIDField], [NSString stringWithFormat:@"%@ ASC", kWaypointIDField]];
	self.query.where = [NSString stringWithFormat:@"%@ LIKE %@", kRouteIDField, routeID];
	
	self.queryTask = [AGSQueryTask queryTaskWithURL:[NSURL URLWithString:kFeatureLayerURLGame]];
	self.queryTask.delegate = self;
	[self.queryTask executeWithQuery:self.query];
}

#pragma mark - AGSQueryTaskDelegate

- (void)queryTask:(AGSQueryTask *)queryTask operation:(NSOperation *)op didExecuteWithFeatureSetResult:(AGSFeatureSet *)featureSet
{
	NSMutableArray *array = [NSMutableArray array];
	
	for (AGSGraphic *feature in featureSet.features)
	{
		NSString *route_id = [feature attributeAsStringForKey:kRouteIDField];
		NSString *route_name = [feature attributeAsStringForKey:kRouteNameField];
		NSDictionary *route = @{kRouteIDField: route_id , kRouteNameField: route_name};
		__block BOOL add = YES;
		
		[array enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop)
		 {
			 if ([dict[kRouteIDField] isEqualToString:route_id])
			 {
				 add = NO;
				 *stop = YES;
			 }
		 }];
		
		if (add)
		{
			[array addObject:route];
		}
	}
	
	self.completion(array);
}

- (void)queryTask:(AGSQueryTask *)queryTask operation:(NSOperation *)op didFailWithError:(NSError *)error
{
	OGLog(error.localizedDescription);
}


#pragma mark - Private Methods

- (NSArray*)createTasksFromFeatureSet:(AGSFeatureSet*)featureSet
{
	AGSGraphic *firstFeature = featureSet.features[0];
	
	OGTask *startTask = [OGTask taskWithAGSGraphic:firstFeature];
	startTask = [OGTask taskWithAGSGraphic:firstFeature];
	startTask.startPoint = nil;
	startTask.destinationPoint = firstFeature.geometry.envelope.center;
	startTask.taskDescription = NSLocalizedString(@"startPointHint", @"Finde den Startpunkt und begib dich dorthin");
	
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


#pragma mark - NSObject

- (NSString *)description
{
	NSMutableString *description = [NSMutableString string];
	
	for (OGTask *task in _tasks)
	{
		[description appendFormat:@"%@\n", task];
	}
	
	return description;
}


@end
