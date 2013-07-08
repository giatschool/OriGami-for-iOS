//
//  OGRoutesListBaseController.m
//  Ori-Gami
//
//  Created by Benni on 11.05.13.
//  Copyright (c) 2013 Ifgi. All rights reserved.
//

#import "OGRoutesListBaseController.h"
#import "OGRouteCell.h"
#import <ArcGIS/ArcGIS.h>

@interface OGRoutesListBaseController () <AGSQueryTaskDelegate>

@property (nonatomic, strong) AGSQuery *query;
@property (nonatomic, strong) AGSQueryTask *queryTask;

@end

@implementation OGRoutesListBaseController

#pragma mark - UIViewController

/**
 When the view appeared, query all routes and show them in the tableView.
 **/
- (void)viewDidAppear:(BOOL)animated
{
	NSString *sqlWhere = [NSString stringWithFormat:@"%@ IS NOT NULL", kRouteIDField];
	
	self.dataArray = [NSMutableArray array];
	self.filteredArray = [NSMutableArray array];
		
	self.query = [AGSQuery query];
	self.query.outFields = [NSArray arrayWithObjects:kRouteIDField, nil];
	self.query.orderByFields = @[[NSString stringWithFormat:@"%@ ASC", kRouteIDField]];
	self.query.where = sqlWhere;
	
	self.queryTask = [AGSQueryTask queryTaskWithURL:[NSURL URLWithString:kFeatureLayerURLGame]];
	self.queryTask.delegate = self;
	[self.queryTask executeWithQuery:self.query];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:@"UITextFieldTextDidChangeNotification" object:self.textField];
}


#pragma mark - AGSQueryTaskDelegate

- (void)queryTask:(AGSQueryTask *)queryTask operation:(NSOperation *)op didExecuteWithFeatureSetResult:(AGSFeatureSet *)featureSet
{
	NSMutableArray *array = [NSMutableArray array];
	
	for (AGSGraphic *feature in featureSet.features)
	{
		NSString *route_id = [feature attributeAsStringForKey:kRouteIDField];
		NSString *route_name = [feature attributeAsStringForKey:kRouteNameField];

		NSMutableDictionary *route = (NSMutableDictionary*)@{kRouteIDField: route_id};
		if (route_name) [route setObject:route_name forKey:kRouteNameField];
		
		__block BOOL add = YES;
		
		[array enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop)
		 {
			 if ([dict[kRouteIDField] isEqualToString:route_id])
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
	
	self.dataArray = [NSMutableArray arrayWithArray:array];
	
	[self.tableView reloadData];
	[self.activityIndicator stopAnimating];
	self.waitlabel.hidden = YES;
}

- (void)queryTask:(AGSQueryTask *)queryTask operation:(NSOperation *)op didFailWithError:(NSError *)error
{
	OGLog(error.localizedDescription);
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if ([self.textField.text isEqualToString:@""])
	{
		return self.dataArray.count;
	}
	else
	{
		return self.filteredArray.count;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    OGRouteCell *cell = (OGRouteCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
	NSDictionary *dict = ([self.textField.text isEqualToString:@""]) ? self.dataArray[indexPath.row] : self.filteredArray[indexPath.row];
	
    cell.idLabel.text = dict[kRouteIDField];
    cell.nameLabel.text = dict[kRouteNameField];
	
    return cell;
}


#pragma mark - Notifications

- (void)textDidChange :(NSNotification *)notification
{
	[self.filteredArray removeAllObjects];
	
	NSString *searchString = self.textField.text;
	
	NSIndexSet *indice = [self.dataArray indexesOfObjectsPassingTest:^BOOL(NSDictionary *route, NSUInteger idx, BOOL *stop)
						  {
							  BOOL passed = NO;
							  
							  if ([route[kRouteIDField] rangeOfString:searchString options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch].location != NSNotFound)
							  {
								  passed = YES;
							  }
							  
							  if (route[kRouteNameField] && [route[kRouteNameField] rangeOfString:searchString options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch].location != NSNotFound)
							  {
								  passed = YES;
							  }
							  
							  return passed;
						  }];
	
	[self.filteredArray addObjectsFromArray:[self.dataArray objectsAtIndexes:indice]];
	
	[self.tableView reloadData];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
