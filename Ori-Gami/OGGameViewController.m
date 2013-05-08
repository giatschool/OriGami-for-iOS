//
//  OGGameViewController.m
//  Ori-Gami
//
//  Created by Benni on 20.02.13.
//  Copyright (c) 2013 Ifgi. All rights reserved.

#import "OGGameViewController.h"
#import <ArcGIS/ArcGIS.h>
#import "OGTask.h"
#import "OGSmileyView.h"
#import <QuartzCore/QuartzCore.h>
#import "OGAudioHelper.h"
#import "OGRoute.h"
#import "OGEndGameViewController.h"

@interface OGGameViewController () <AGSMapViewLayerDelegate, AGSLayerDelegate, AGSFeatureLayerQueryDelegate>
@property (weak, nonatomic) IBOutlet AGSMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *taskLabel;
@property (weak, nonatomic) IBOutlet OGSmileyView *smileyView;
@property (weak, nonatomic) IBOutlet UIImageView *paperBackgroundImageView;

@property (nonatomic, strong) AGSFeatureLayer *featureLayer;
@property (nonatomic, strong) OGRoute *route;

@end

@implementation OGGameViewController

#pragma mark - UIViewController

/**
 First, the game state is set to starting.
 Then we set a nice shadow for the paper background on the instructions.
 Next, we configure the MapView with a basemap and a delegate.
 Then the feature layer is created and configured with a uniquevalue renderer
 Also, the smiley view is reset to his default, neutral value;
 **/
- (void)viewDidLoad
{
    [super viewDidLoad];
		
	[self setupPaperBackgroundView];
	[self setupMapView];
	[self setupFeatureLayer];
	[self setupRenderer];
	
	[self.smileyView reset];
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
	[self.mapView addMapLayer:self.featureLayer withName:@"Feature Layer"];
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
	if (featureSet.features.count > 1)
	{
		self.route = [OGRoute routeWithFeatureSet:featureSet startingPoint:self.mapView.locationDisplay.mapLocation];

		[self.mapView zoomToScale:30000.0 withCenterPoint:self.route.currentTask.startPoint animated:YES];
	}
	else
	{
		NSLog(@"%@", @"No features found in route");
		[self endGame];
	}
}

/**
 When the layer fails to query features, we log an error message
 **/
- (void)featureLayer:(AGSFeatureLayer *)featureLayer operation:(NSOperation *)op didFailSelectFeaturesWithError:(NSError *)error
{
	NSLog(@"%s - %@", __func__, error.localizedDescription);
}


#pragma mark - Key-Value-Observing

/**
 KVO method to catch observed values that have changed. 
 In this case only the location is observed to call the "updateLocation" method on a location change
**/
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ([keyPath isEqual:@"location"])
	{
		[self updateLocation];
	}
}


#pragma mark - Setup Methods

/**
 Setup the map view with self as delegate and an OSM basemap
 **/
- (void)setupMapView
{
	AGSOpenStreetMapLayer *basemapLayer = [AGSOpenStreetMapLayer openStreetMapLayer];
	basemapLayer.renderNativeResolution = YES;
	self.mapView.layerDelegate = self;
	[self.mapView addMapLayer:basemapLayer withName:@"Basemap Layer"];
}

/**
 Helper method to setup a unique renderer that renders a flag for the start point and nothing for the following waypoints.
 **/
- (void)setupRenderer
{
	AGSPictureMarkerSymbol *pictureSymbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"flag"]];
	AGSPictureMarkerSymbol *emptySymbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@""]];
	AGSUniqueValue *uniqueValue = [AGSUniqueValue uniqueValueWithValue:@"0" symbol:pictureSymbol];
	
	AGSUniqueValueRenderer *uniqueValueRenderer = [[AGSUniqueValueRenderer alloc] init];
	uniqueValueRenderer.defaultSymbol = emptySymbol;
	uniqueValueRenderer.uniqueValues = @[uniqueValue];
	uniqueValueRenderer.fields = @[kWaypointIDField];
	
	self.featureLayer.renderer = uniqueValueRenderer;
}

/**
 Helper method to setup the feature layer to only fetch features from the previously selected route_id
 **/
- (void)setupFeatureLayer
{
	self.featureLayer = [AGSFeatureLayer featureServiceLayerWithURL:[NSURL URLWithString:kFeatureLayerURLGame] mode:AGSFeatureLayerModeSnapshot];
	self.featureLayer.definitionExpression = [NSString stringWithFormat:@"%@ LIKE '%@'", kRouteIDField, self.routeID];
	self.featureLayer.delegate = self;
	self.featureLayer.queryDelegate = self;
}

/**
 A helper method to give the paper background view a nice shadow
 **/
- (void)setupPaperBackgroundView
{
	self.paperBackgroundImageView.layer.shadowOpacity = 1.0;
	self.paperBackgroundImageView.layer.shadowOffset = CGSizeMake(0.0, 0.0);
	self.paperBackgroundImageView.layer.shadowRadius = 10.0;
	self.paperBackgroundImageView.layer.backgroundColor = [[UIColor blackColor] CGColor];
}


#pragma mark - Update Methods

/**
 Sets the task label text to the current task and updates the smiley view.
 The calculated value for the smiley view is be divided 2.0 to let the smiley start in a neutral position.
 Also the value must be subtracted from 1 because the smiley smiles with a value of 1 and is sad at 0.
 **/
- (void)updateInterface
{
	self.taskLabel.text = self.route.currentTask.taskDescription;
	
	CGFloat distanceTotal = [self.route.currentTask distanceToDestinationFromStartPoint];
	CGFloat distanceRemaining = [self.route.currentTask distanceToDestinationFromPoint:self.mapView.locationDisplay.mapLocation];
	CGFloat newValue = distanceRemaining / distanceTotal;
//	NSLog(@"%1.2f / %1.2f = %1.2f", distanceRemaining, distanceTotal, newValue);
		
	self.smileyView.value = 1 - (newValue / 2.0);
}

/**
 The interface is updated, so that the smiley view reflects the current distance status.
 Then the remaining distance is calculated and if it is less than 50 meters (?) the current task is complete and the next waypoint is unlocked
 **/
- (void)updateLocation
{
	[self updateInterface];

	AGSPoint *currentPoint = self.mapView.locationDisplay.mapLocation;
	double distanceInMeter = [self.route.currentTask distanceToDestinationFromPoint:currentPoint];
	// TODO: Fix the bug with the wrong distance
	// NSLog(@"%1.2f - %1.2f  |  %1.2f - %1.2f  |  %1.2fm", currentPoint.x, currentPoint.y, self.currentTask.destinationPoint.x, self.currentTask.destinationPoint.y, distanceInMeter);
		
	if (distanceInMeter > 0.0 && distanceInMeter < kDestinationRadius)
	{
		[self unlockNextTask];
	}
}


#pragma mark - Segue Handling

/**
 Reaction to different segues
 1. New ViewController is shown when the game is finished
 **/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"showGameFinished"])
	{
		OGEndGameViewController *controller = (OGEndGameViewController*)segue.destinationViewController;
		controller.route = self.route;
	}
}


#pragma mark - Action Methods

/**
 debug method
 **/
- (IBAction)unlock:(id)sender
{
	[self unlockNextTask];
}


#pragma mark - Other private methods

/**
 The query where clause is updated with a new waypoint_id (current task waypoint number + 1) and the feature layer selects features with the updated query
 **/
- (void)unlockNextTask
{
	[self.route unlockNextTask];
	
	switch (self.route.gameState)
	{
		case OGGameStateRunning:
			[OGAudioHelper playMP3SoundWithName:@"trumpet" error:NULL];
			[self updateInterface];
			break;
		case OGGameStateFinished:
			[self endGame];
			break;
		default:
			break;
	}
}

/**
 This method is called when no features are selected, which means that the game is over and the goal is reached.
 **/
- (void)endGame
{
	[self.mapView.locationDisplay stopDataSource];
	
	[OGAudioHelper playMP3SoundWithName:@"applause" error:NULL];
	[self performSegueWithIdentifier:@"showGameFinished" sender:self];
}

@end
