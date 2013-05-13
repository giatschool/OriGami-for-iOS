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



#pragma mark - Subscripting

- (OGTask*)objectAtIndexedSubscript:(NSUInteger)idx
{
	return self.tasks[idx];
}


#pragma mark - NSObject

- (NSString *)description
{
	NSMutableString *description = [NSMutableString string];
	
	for (OGTask *task in self.tasks)
	{
		[description appendFormat:@"%@\n", task];
	}
	
	return description;
}


@end
