//
//  OGRouteCell.m
//  Ori-Gami
//
//  Created by Benni on 16.03.13.
//  Copyright (c) 2013 Ifgi. All rights reserved.
//

#import "OGRouteCell.h"
#import <ArcGIS/ArcGIS.h>
#import "OGRoute.h"

@interface OGRouteCell () <AGSMapViewLayerDelegate, AGSLayerDelegate, AGSFeatureLayerQueryDelegate>
@property (nonatomic, weak) IBOutlet AGSMapView *mapView;
@property (nonatomic, strong) AGSFeatureLayer *featureLayer;
@property (nonatomic, strong) OGRoute *route;
@end


@implementation OGRouteCell


#pragma mark - Initialize

- (void)awakeFromNib
{
	
}


#pragma mark - Public methods

- (void)loadRoute:(NSString*)routeID
{
	self.featureLayer = [AGSFeatureLayer featureServiceLayerWithURL:[NSURL URLWithString:kFeatureLayerURLGame] mode:AGSFeatureLayerModeSnapshot];
	self.featureLayer.definitionExpression = [NSString stringWithFormat:@"%@ LIKE '%@'", kRouteIDField, routeID];
	self.featureLayer.delegate = self;
	self.featureLayer.queryDelegate = self;

	[self.mapView addMapLayer:self.featureLayer withName:@"Feature Layer"];
}

#pragma mark - AGSMapViewDelegate

/**
 When the map loads, the GPS tracking is started and an observer is added to the location, so we get updates and can react on them.
 Also the feature layer is added to the map.
 **/
- (void)mapViewDidLoad:(AGSMapView*)mapView
{
 	[self.mapView.locationDisplay startDataSource];
	[self.mapView.locationDisplay addObserver:self forKeyPath:@"location" options:(NSKeyValueObservingOptionNew) context:NULL];
	
	
}


#pragma mark - AGSLayerDelegate

/**
 A query that returns the first waypoint with the selected route id is created and added to the featureLayer for selecting.
 Starts the feature selection now to make sure that the layer was properly loaded on the map
 Animates the debug button in.
 **/
- (void)layerDidLoad:(AGSLayer *)layer
{
	if ([layer isKindOfClass:[AGSFeatureLayer class]])
	{
		AGSQuery *query = [AGSQuery query];
		query.outFields = [NSArray arrayWithObjects:@"*", nil];
		query.orderByFields = @[[NSString stringWithFormat:@"%@ ASC", kWaypointIDField]];
		query.where = [NSString stringWithFormat:@"%@ >= 0", kWaypointIDField];
		
		[self.featureLayer selectFeaturesWithQuery:query selectionMethod:AGSFeatureLayerSelectionMethodNew];
	}
}

/**
 If a layer fails to load, log the error
 **/
- (void)layer:(AGSLayer *)layer didFailToLoadWithError:(NSError *)error
{
	NSLog(@"%@", error.localizedDescription);
}


#pragma mark - AGSFeatureLayerQueryDelegate

/**
 When the feature layer finishes loading the features, if there are any features,
 the first one is transformed to the new current task and the interface is updated.
 **/
- (void)featureLayer:(AGSFeatureLayer *)featureLayer operation:(NSOperation *)op didSelectFeaturesWithFeatureSet:(AGSFeatureSet *)featureSet
{
	self.route = [OGRoute routeWithFeatureSet:featureSet startingPoint:self.mapView.locationDisplay.mapLocation];
	
	
}

/**
 When the layer fails to query features, we log an error message
 **/
- (void)featureLayer:(AGSFeatureLayer *)featureLayer operation:(NSOperation *)op didFailSelectFeaturesWithError:(NSError *)error
{
	NSLog(@"%s - %@", __func__, error.localizedDescription);
}



@end
