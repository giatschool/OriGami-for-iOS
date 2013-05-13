//
//  OGRoute.h
//  Ori-Gami
//
//  Created by Benni on 11.05.13.
//  Copyright (c) 2013 Ifgi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OGTask;
@class AGSFeatureSet;
@class AGSPoint;

typedef void (^RouteCompletionBlock)(NSArray *routes);


@interface OGRoute : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *routeID;

+ (instancetype)routeWithFeatureSet:(AGSFeatureSet*)featureSet startingPoint:(AGSPoint*)startingPoint;
- (id)initWithFeatureSet:(AGSFeatureSet*)featureSet startingPoint:(AGSPoint*)startingPoint;
- (void)queryAllRoutes:(RouteCompletionBlock)completion;
- (OGTask*)objectAtIndexedSubscript:(NSUInteger)idx;

@end
