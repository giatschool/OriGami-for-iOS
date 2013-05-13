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

- (void)routesListController:(OGRoutesListEditorController*)routesListController didDeleteRoute:(OGEditorRoute*)route;
- (void)routesListController:(OGRoutesListEditorController*)routesListController didSelectRoute:(OGEditorRoute*)route;

@end


@interface OGRoutesListEditorController : UITableViewController

@property (nonatomic, assign) BOOL canEdit;
@property (nonatomic, assign) id <OGRoutesListDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end
