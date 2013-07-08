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
#import "OGRoutesListEditorController.h"
#import "OGTask.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+Extensions.h"
#import "OGEditWaypointViewController.h"

@interface OGEditorViewController () <AGSMapViewCalloutDelegate, UIPopoverControllerDelegate, AGSFeatureLayerEditingDelegate, AGSFeatureLayerQueryDelegate, AGSLayerDelegate, AGSMapViewTouchDelegate, AGSMapViewLayerDelegate, AGSQueryTaskDelegate, OGRouteEditDelegate, OGRoutesListDelegate, AGSInfoTemplateDelegate>

@property (weak, nonatomic) IBOutlet AGSMapView *mapView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *infoButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *listButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;

@property (nonatomic, strong) UIPopoverController *myPopover;

@property (nonatomic, strong) AGSFeatureLayer *featureLayer;
@property (nonatomic, strong) OGEditorRoute *selectedRoute;

//@property (nonatomic, strong) OGEditWaypointViewController *waypointViewController;
@property (nonatomic, strong) UINavigationController *waypointViewController;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end


@implementation OGEditorViewController


#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];	
	
//	[self setupMapView];
//	
//	self.infoButton.enabled = NO;
//
//	UINavigationController *navController = (UINavigationController*)[self.storyboard instantiateViewControllerWithIdentifier:@"waypointController"];
////	self.waypointViewController = (OGEditWaypointViewController*)navController.viewControllers[0];
//	self.waypointViewController = navController;
	
	[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://giv-learn2.uni-muenster.de/origami/editor/"]]];
}


#pragma mark - AGSMapViewDelegate

- (void)mapViewDidLoad:(AGSMapView*)mapView
{
	[self setupFeatureLayer];
	[self.mapView.locationDisplay startDataSource];
}



#pragma mark - AGSMapViewCalloutDelegate

- (BOOL)mapView:(AGSMapView *)mapView shouldShowCalloutForGraphic:(AGSGraphic *)graphic
{
	int waypointIndex = [(NSNumber*)[graphic attributeForKey:kWaypointIDField] intValue];
	OGTask *task = self.selectedRoute[waypointIndex];
	
	OGEditWaypointViewController *waypointViewController = (OGEditWaypointViewController*)self.waypointViewController.viewControllers[0];
	waypointViewController.task = task;
	self.mapView.callout.customView = self.waypointViewController.view;
	self.mapView.callout.customView.frame = CGRectMake(20.0, 0.0, 320.0, 219.0);
	
	return YES;
}



#pragma mark - AGSMapViewTouchDelegate

- (void)mapView:(AGSMapView *)mapView didClickAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint graphics:(NSDictionary *)graphics
{

	
}



#pragma mark - Action Methods

- (IBAction)closeButtonPressed:(id)sender
{
	NSString *title = NSLocalizedString(@"close", @"Schließen");
	NSString *message = NSLocalizedString(@"closeEditorHint",  @"Editor wird geschlossen und die aktuelle Route gespeichert.";);
	NSString *okButton = NSLocalizedString(@"ok", @"OK");
	NSString *cancelButton = NSLocalizedString(@"cancel", @"Abbrechen");
	
	UIAlertView *alertView = [UIAlertView alertViewWithTitle:title message:message cancelButtonTitle:cancelButton otherButtonTitles:okButton, nil];
	alertView.dismissalBlock = ^(NSInteger buttonIndex){
		if (buttonIndex == 1)
		{
//			if (self.mapView.locationDisplay.isDataSourceStarted)
//			{
//				[self.mapView.locationDisplay stopDataSource];
//				[self.mapView.locationDisplay addObserver:self forKeyPath:@"location" options:(NSKeyValueObservingOptionNew) context:NULL];
//			}
//
//			[self.myPopover dismissPopoverAnimated:YES];
//			self.myPopover = nil;
			
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
		
		OGRoutesListEditorController *routesListController = (OGRoutesListEditorController*)((UINavigationController*)segue.destinationViewController).viewControllers[0];
		routesListController.delegate = self;
		routesListController.canEdit = self.featureLayer.canDelete;
	}
	
	if ([segue.identifier isEqualToString:@"showAddRoute"])
	{
		OGEditorRoute *newRoute = [OGEditorRoute new];
		
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

- (void)routesListController:(OGRoutesListEditorController *)routesListController didDeleteRouteWithID:(NSString *)routeID
{
	[self.myPopover dismissPopoverAnimated:YES];
	self.myPopover = nil;

}

- (void)routesListController:(OGRoutesListEditorController *)routesListController didSelectRouteWithID:(NSString *)routeID
{
	[self setupFeatureLayer];
	[self loadRouteWithIDIntoFeatureLayer:routeID];

	self.infoButton.enabled = YES;
	
	[self.myPopover dismissPopoverAnimated:YES];
	self.myPopover = nil;
}


#pragma mark - AGSFeatureLayerQueryDelegate

- (void)featureLayer:(AGSFeatureLayer *)featureLayer operation:(NSOperation *)op didSelectFeaturesWithFeatureSet:(AGSFeatureSet *)featureSet
{
	if (featureSet.features.count > 1)
	{
		self.selectedRoute = (OGEditorRoute*)[OGEditorRoute routeWithFeatureSet:featureSet];
		

		[self.mapView zoomToEnvelope:featureLayer.fullEnvelope animated:YES];
	}
}

- (void)featureLayer:(AGSFeatureLayer *)featureLayer operation:(NSOperation *)op didFailSelectFeaturesWithError:(NSError *)error
{

}



#pragma mark - Private Methods

- (void)setupMapView
{
	AGSOpenStreetMapLayer *basemapLayer = [AGSOpenStreetMapLayer openStreetMapLayer];
	basemapLayer.renderNativeResolution = YES;
	self.mapView.layerDelegate = self;
	self.mapView.touchDelegate = self;
	self.mapView.calloutDelegate = self;
	[self.mapView addMapLayer:basemapLayer withName:@"Basemap Layer"];
	[self.mapView.locationDisplay addObserver:self forKeyPath:@"location" options:(NSKeyValueObservingOptionNew) context:NULL];
}

/**
 Helper method to setup the feature layer to only fetch features from the selected route
 **/
- (void)setupFeatureLayer
{
	self.featureLayer = [AGSFeatureLayer featureServiceLayerWithURL:[NSURL URLWithString:kFeatureLayerURLEditor] mode:AGSFeatureLayerModeSnapshot];
	self.featureLayer.delegate = self;
	self.featureLayer.infoTemplateDelegate = self;
	self.featureLayer.queryDelegate = self;
	self.featureLayer.definitionExpression = [NSString stringWithFormat:@"%@ LIKE '%@'", kRouteIDField, @""];

	[self.mapView removeMapLayerWithName:@"Feature Layer"];
	[self.mapView addMapLayer:self.featureLayer withName:@"Feature Layer"];
	
	[self setupRenderer];
}

- (void)loadRouteWithIDIntoFeatureLayer:(NSString*)routeID
{
	AGSQuery *query = [AGSQuery query];
	query.outFields = [NSArray arrayWithObjects:@"*", nil];
	query.orderByFields = @[[NSString stringWithFormat:@"%@ ASC", kWaypointIDField]];
	query.where = [NSString stringWithFormat:@"%@ >= 0", kWaypointIDField];
	
	self.featureLayer.definitionExpression = [NSString stringWithFormat:@"%@ LIKE '%@'", kRouteIDField, routeID];

	[self.featureLayer selectFeaturesWithQuery:query selectionMethod:AGSFeatureLayerSelectionMethodNew];	
}

/**
 Helper method to setup a custom renderer that renders numbers for the waypoints according to their IDs
 **/
- (void)setupRenderer
{
	AGSPictureMarkerSymbol *pictureSymbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:@"flag"]];
	
	AGSUniqueValueRenderer *uniqueValueRenderer = [[AGSUniqueValueRenderer alloc] init];
	uniqueValueRenderer.defaultSymbol = pictureSymbol;
	uniqueValueRenderer.fields = @[kWaypointIDField];
	
	NSMutableArray *uniqueValues = [NSMutableArray new];
	
	for (int i = 0; i < 20; i++)
	{
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 30.0, 30.0)];
		label.text = [NSString stringWithFormat:@"%i", i];
		label.textColor = [UIColor whiteColor];
		label.textAlignment = NSTextAlignmentCenter;
		label.backgroundColor = [UIColor blueColor];
		label.font = [UIFont boldSystemFontOfSize:15.0];
		label.opaque = NO;
		label.layer.borderColor = [UIColor whiteColor].CGColor;
		label.layer.borderWidth = 3.0;
		label.layer.cornerRadius = 15.0;
		
		UIImage *image = [label screenshot];
		AGSPictureMarkerSymbol *pictureSymbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:image];

		AGSUniqueValue *uniqueValue = [AGSUniqueValue uniqueValueWithValue:label.text symbol:pictureSymbol];

		[uniqueValues addObject:uniqueValue];
	}
	
	uniqueValueRenderer.uniqueValues = uniqueValues;

	self.featureLayer.renderer = uniqueValueRenderer;
}


#pragma mark - UIPopoverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
	self.myPopover = nil;
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
		//[self.mapView zoomToScale:30000.0 withCenterPoint:self.mapView.locationDisplay.location.point animated:YES];
		
		[self.mapView.locationDisplay stopDataSource];
		[self.mapView.locationDisplay removeObserver:self forKeyPath:@"location"];
	}
}

@end
