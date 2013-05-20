//
//  OGRoutesListViewController.h
//  Ori-Gami
//
//  Created by Benni on 10.05.13.
//  Copyright (c) 2013 Ifgi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OGRoutesListBaseController.h"

@class OGRoutesListEditorController;
@class OGEditorRoute;

@protocol OGRoutesListDelegate <NSObject>

- (void)routesListController:(OGRoutesListEditorController*)routesListController didDeleteRouteWithID:(NSString*)routeID;
- (void)routesListController:(OGRoutesListEditorController*)routesListController didSelectRouteWithID:(NSString*)routeID;

@end


@interface OGRoutesListEditorController : OGRoutesListBaseController

@property (nonatomic, assign) BOOL canEdit;
@property (nonatomic, assign) id <OGRoutesListDelegate> delegate;

@end
