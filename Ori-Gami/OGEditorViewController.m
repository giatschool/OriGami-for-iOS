//
//  OGEditorViewController.m
//  Ori-Gami
//
//  Created by Benni on 09.05.13.
//  Copyright (c) 2013 Ifgi. All rights reserved.
//

#import "OGEditorViewController.h"
#import "MPFoldTransition.h"
#import <ArcGIS/ArcGIS.h>
#import "OGEditorRoute.h"
#import "OGRoutesListEditorController.h"
#import "OGEditRouteViewController.h"
#import "UIAlertView+Extensions.h"
#import "OGWaypointRenderer.h"

@interface OGEditorViewController () <AGSMapViewCalloutDelegate, UIPopoverControllerDelegate, AGSFeatureLayerEditingDelegate, AGSFeatureLayerQueryDelegate, AGSLayerDelegate, AGSMapViewTouchDelegate, AGSMapViewLayerDelegate, AGSQueryTaskDelegate, OGRouteEditDelegate, OGRoutesListDelegate>

@property (weak, nonatomic) IBOutlet AGSMapView *mapView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *infoButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *listButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;

@property (nonatomic, strong) UIPopoverController *myPopover;

@property (nonatomic, strong) AGSFeatureLayer *featureLayer;
@property (nonatomic, strong) AGSQuery *query;
@property (nonatomic, strong) AGSQueryTask *queryTask;

@property (nonatomic, strong) OGEditorRoute *selectedRoute;
@property (nonatomic, strong) NSMutableArray *routes;

@end


@implementation OGEditorViewController


#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];	
	
	AGSOpenStreetMapLayer *basemapLayer = [AGSOpenStreetMapLayer openStreetMapLayer];
	basemapLayer.renderNativeResolution = YES;
	self.mapView.layerDelegate = self;
	self.mapView.touchDelegate = self;
	self.mapView.calloutDelegate = self;
	[self.mapView addMapLayer:basemapLayer withName:@"Basemap Layer"];
	[self.mapView.locationDisplay addObserver:self forKeyPath:@"location" options:(NSKeyValueObservingOptionNew) context:NULL];

	self.infoButton.enabled = NO;
	self.listButton.enabled = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[self loadAllRoutes];
}



#pragma mark - AGSMapViewDelegate

- (void)mapViewDidLoad:(AGSMapView*)mapView
{
	[self setupFeatureLayer];
	[self setupRenderer];
	
	[self.mapView addMapLayer:self.featureLayer withName:@"Feature Layer"];
	[self.mapView.locationDisplay startDataSource];
}



#pragma mark - AGSMapViewCalloutDelegate

- (BOOL)mapView:(AGSMapView *)mapView shouldShowCalloutForGraphic:(AGSGraphic *)graphic
{
	return YES;
}



#pragma mark - AGSMapViewTouchDelegate

- (void)mapView:(AGSMapView *)mapView didClickAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint graphics:(NSDictionary *)graphics
{
	NSLog(@"%@", mappoint);

}



#pragma mark - Action Methods

- (IBAction)closeButtonPressed:(id)sender
{
	NSString *title = @"Schließen";
	NSString *message = @"Editor wird geschlossen und die aktuelle Route gespeichert.";
	NSString *okButton = @"OK";
	NSString *cancelButton = @"Cancel";
	
	UIAlertView *alertView = [UIAlertView alertViewWithTitle:title message:message cancelButtonTitle:cancelButton otherButtonTitles:okButton, nil];
	alertView.dismissalBlock = ^(NSInteger buttonIndex){
		if (buttonIndex == 1)
		{
			if (self.mapView.locationDisplay.isDataSourceStarted)
			{
				[self.mapView.locationDisplay stopDataSource];
				[self.mapView.locationDisplay addObserver:self forKeyPath:@"location" options:(NSKeyValueObservingOptionNew) context:NULL];
			}

			[self.myPopover dismissPopoverAnimated:YES];
			self.myPopover = nil;
			
			[self.presentingViewController dismissViewControllerWithFoldStyle:MPFoldStyleCubic completion:^(BOOL finished) {
				
			}];			
		}
	};
	
	[alertView show];
}



#pragma mark - Segue Handling

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
	if ([identifier isEqualToString:@"showRoutes"])
	{
		if (self.myPopover)
		{
			[self.myPopover dismissPopoverAnimated:YES];
			self.myPopover = nil;
			return NO;
		}
		else
		{
			return YES;
		}
	}
	
	return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"showRoutes"])
	{
		self.myPopover = [(UIStoryboardPopoverSegue *)segue popoverController];
		self.myPopover.delegate = self;
		
		OGRoutesListEditorController *routesViewController = (OGRoutesListEditorController*)((UINavigationController*)segue.destinationViewController).viewControllers[0];
		routesViewController.delegate = self;
		routesViewController.canEdit = self.featureLayer.canDelete;
		routesViewController.dataArray = [NSMutableArray arrayWithArray:self.routes];
	}
	
	if ([segue.identifier isEqualToString:@"showAddRoute"])
	{
		OGEditorRoute *newRoute = [OGEditorRoute new];
		[self.routes addObject:newRoute];
		
		OGEditRouteViewController *routeViewController = (OGEditRouteViewController*)((UINavigationController*)segue.destinationViewController).viewControllers[0];
		routeViewController.route = newRoute;
		routeViewController.delegate = self;
		routeViewController.isAddingNewRoute = YES;
	}
	
	if ([segue.identifier isEqualToString:@"showEditRoute"])
	{
		OGEditRouteViewController *routeViewController = (OGEditRouteViewController*)((UINavigationController*)segue.destinationViewController).viewControllers[0];
		routeViewController.route = self.selectedRoute;
		routeViewController.delegate = self;
		routeViewController.isAddingNewRoute = NO;
	}
}



#pragma mark - OGRouteEditDelegate

- (void)editRouteController:(OGEditRouteViewController *)editRouteController didCancelRoute:(OGEditorRoute *)route
{
	[self.routes removeObject:route];
	self.selectedRoute = nil;

	self.infoButton.enabled = NO;
	
	[self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)editRouteController:(OGEditRouteViewController *)editRouteController didSaveRoute:(OGEditorRoute *)route
{
	self.selectedRoute = route;
	self.infoButton.enabled = YES;

	[self dismissViewControllerAnimated:YES completion:NULL];
}



#pragma mark - OGRoutesListDelegate

- (void)routesListController:(OGRoutesListEditorController *)routesListController didDeleteRoute:(OGEditorRoute *)route
{
	
}

- (void)routesListController:(OGRoutesListEditorController *)routesListController didSelectRoute:(OGEditorRoute *)route
{
	self.selectedRoute = route;
	self.infoButton.enabled = YES;
	
	[self.myPopover dismissPopoverAnimated:YES];
	self.myPopover = nil;
	
	[self setupFeatureLayer];
	[self loadRouteIntoFeatureLayer];
}



#pragma mark - AGSFeatureLayerQueryDelegate

/**
 When the feature layer finishes loading the features, if there are any features,
 the first one is transformed to the new current task and the interface is updated.
 **/
- (void)featureLayer:(AGSFeatureLayer *)featureLayer operation:(NSOperation *)op didSelectFeaturesWithFeatureSet:(AGSFeatureSet *)featureSet
{
	if (featureSet.features.count > 0)
	{
		NSLog(@"Found %i features", featureSet.features.count);
	}
	else
	{
		NSLog(@"%@", @"No features found in route");
	}
}

/**
 When the layer fails to query features, we log an error message
 **/
- (void)featureLayer:(AGSFeatureLayer *)featureLayer operation:(NSOperation *)op didFailSelectFeaturesWithError:(NSError *)error
{
	NSLog(@"%s - %@", __func__, error.localizedDescription);
}



#pragma mark - Private Methods

- (void)loadAllRoutes
{
	self.query = [AGSQuery query];
	self.query.outFields = [NSArray arrayWithObjects:kRouteIDField, nil];
	self.query.orderByFields = @[[NSString stringWithFormat:@"%@ ASC", kRouteIDField]];
	self.query.where = [NSString stringWithFormat:@"%@ IS NOT NULL", kRouteIDField];
	
	self.queryTask = [AGSQueryTask queryTaskWithURL:[NSURL URLWithString:kFeatureLayerURLGame]];
	self.queryTask.delegate = self;
	[self.queryTask executeWithQuery:self.query];
}

/**
 Helper method to setup the feature layer to only fetch features from the selected route
 **/
- (void)setupFeatureLayer
{
	self.featureLayer = [AGSFeatureLayer featureServiceLayerWithURL:[NSURL URLWithString:kFeatureLayerURLEditor] mode:AGSFeatureLayerModeSnapshot];
	self.featureLayer.definitionExpression = [NSString stringWithFormat:@"%@ LIKE '%@'", kRouteIDField, self.selectedRoute.routeID];
	self.featureLayer.delegate = self;
	self.featureLayer.queryDelegate = self;
}

- (void)loadRouteIntoFeatureLayer
{
	AGSQuery *query = [AGSQuery query];
	query.outFields = [NSArray arrayWithObjects:@"*", nil];
	query.orderByFields = @[[NSString stringWithFormat:@"%@ ASC", kWaypointIDField]];
	query.where = [NSString stringWithFormat:@"%@ >= 0", kWaypointIDField];
	
	[self.featureLayer selectFeaturesWithQuery:query selectionMethod:AGSFeatureLayerSelectionMethodNew];	
}

/**
 Helper method to setup a custom renderer that renders numbers for the waypoints according to their IDs
 **/
- (void)setupRenderer
{
	OGWaypointRenderer *waypointRenderer = [[OGWaypointRenderer alloc] init];

//	
//	AGSPictureMarkerSymbol *pictureSymbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"flag"]];
////	AGSPictureMarkerSymbol *emptySymbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@""]];
////	AGSUniqueValue *uniqueValue = [AGSUniqueValue uniqueValueWithValue:@"0" symbol:pictureSymbol];
//	
//	AGSUniqueValueRenderer *uniqueValueRenderer = [[AGSUniqueValueRenderer alloc] init];
//	uniqueValueRenderer.defaultSymbol = pictureSymbol;
////	uniqueValueRenderer.uniqueValues = @[uniqueValue];
//	uniqueValueRenderer.fields = @[kWaypointIDField];
//	
	self.featureLayer.renderer = waypointRenderer;
}


#pragma mark - UIPopoverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
	self.myPopover = nil;
}



#pragma mark - AGSQueryTaskDelegate

- (void)queryTask:(AGSQueryTask *)queryTask operation:(NSOperation *)op didExecuteWithFeatureSetResult:(AGSFeatureSet *)featureSet
{
	NSMutableArray *array = [NSMutableArray array];
	
	for (AGSGraphic *feature in featureSet.features)
	{
		NSString *route_id = [feature attributeAsStringForKey:kRouteIDField];
		NSString *route_name = [feature attributeAsStringForKey:kRouteNameField];
		
		OGEditorRoute *route = [OGEditorRoute editorRouteWithName:route_name id:route_id];
		
		__block BOOL add = YES;
		
		[array enumerateObjectsUsingBlock:^(OGEditorRoute *loopRoute, NSUInteger idx, BOOL *stop)
		 {
			 if ([loopRoute.routeID isEqualToString:route_id])
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
	
	self.routes = [NSMutableArray arrayWithArray:array];

	self.listButton.enabled = YES;
}

- (void)queryTask:(AGSQueryTask *)queryTask operation:(NSOperation *)op didFailWithError:(NSError *)error
{
	OGLog(error.localizedDescription);
}




#pragma mark - Key-Value-Observing

/**
 KVO method to catch observed values that have changed.
 In this case only the location is observed to zoom to the user location and stop the observing afterwards
 **/
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ([keyPath isEqual:@"location"])
	{
		[self.mapView zoomToScale:30000.0 withCenterPoint:self.mapView.locationDisplay.mapLocation animated:YES];
		[self.mapView.locationDisplay stopDataSource];
		[self.mapView.locationDisplay removeObserver:self forKeyPath:@"location"];
	}
}



@end
