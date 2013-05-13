//
//  OGEditRouteViewController.h
//  Ori-Gami
//
//  Created by Benni on 10.05.13.
//  Copyright (c) 2013 Ifgi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OGEditorRoute.h"

@class OGEditorRoute;
@class OGEditRouteViewController;

@protocol OGRouteEditDelegate <NSObject>
- (void)editRouteController:(OGEditRouteViewController*)editRouteController didCancelRoute:(OGEditorRoute*)route;
- (void)editRouteController:(OGEditRouteViewController*)editRouteController didSaveRoute:(OGEditorRoute*)route;
@end


@interface OGEditRouteViewController : UITableViewController

@property (nonatomic, strong) OGEditorRoute *route;
@property (nonatomic, assign) id <OGRouteEditDelegate> delegate;
@property (nonatomic, assign) BOOL isAddingNewRoute;


@end
