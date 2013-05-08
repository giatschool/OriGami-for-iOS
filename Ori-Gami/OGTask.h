//
//  OGTask.h
//  Ori-Gami
//
//  Created by Benni on 11.03.13.
//  Copyright (c) 2013 Ifgi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ArcGIS/ArcGIS.h>

@interface OGTask : NSObject

@property (nonatomic, strong) AGSPoint *destinationPoint;
@property (nonatomic, strong) AGSPoint *startPoint;
@property (nonatomic, strong) NSString *taskDescription;
@property (nonatomic, assign) NSInteger waypointNumber;

+ (instancetype)taskWithAGSGraphic:(AGSGraphic*)graphic;
- (CGFloat)distanceToDestinationFromPoint:(AGSPoint*)point;
- (CGFloat)distanceToDestinationFromStartPoint;


@end
