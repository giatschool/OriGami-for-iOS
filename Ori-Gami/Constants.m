//
//  Constants.m
//  MyAlbums
//
//  Created by Benni on 02.01.13.
//
//

#import "Constants.h"


const CGFloat kAlbumEnlargeDuration = 0.5;

const NSInteger kMaximumImageWidth = 640;

NSString *const kBaseMapURL = @"http://services.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer";
NSString *const kFeatureLayerURLGame = @"http://giv-learn2.uni-muenster.de/arcgis/rest/services/GeoSpatialLearning/route/MapServer/0";
NSString *const kFeatureLayerURLEditor = @"http://giv-learn2.uni-muenster.de/arcgis/rest/services/GeoSpatialLearning/route/FeatureServer/0";

NSString *const kRouteIDField = @"route_id";
NSString *const kWaypointIDField = @"waypoint_id";
NSString *const kDescriptionField = @"description";
NSString *const kRouteNameField = @"name";

//NSString *const kDebugRouteID = @"Vehj9";
//NSString *const kDebugRouteID = @"qs1LZ";
NSString *const kDebugRouteID = @"Wn7dH";

CGFloat const kDestinationRadius = 40.0;
