//
//  OGPossibleRoutesViewController.m
//  Ori-Gami
//
//  Created by Benni on 13.03.13.
//  Copyright (c) 2013 Ifgi. All rights reserved.
//

#import "OGPossibleRoutesViewController.h"
#import <ArcGIS/ArcGIS.h>
#import "MPFlipTransition.h"
#import <QuartzCore/QuartzCore.h>
#import "OGRouteSelectionViewController.h"


@interface OGPossibleRoutesViewController () <AGSQueryTaskDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *paperBackgroundImageView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSMutableArray *filteredArray;
@property (nonatomic, strong) AGSQuery *query;
@property (nonatomic, strong) AGSQueryTask *queryTask;
@end

@implementation OGPossibleRoutesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.paperBackgroundImageView.layer.shadowOpacity = 1.0;
	self.paperBackgroundImageView.layer.shadowOffset = CGSizeMake(0.0, 0.0);
	self.paperBackgroundImageView.layer.shadowRadius = 10.0;
	self.paperBackgroundImageView.layer.backgroundColor = [[UIColor blackColor] CGColor];
	
	self.dataArray = [NSArray array];
	self.filteredArray = [NSMutableArray array];
		
	self.query = [AGSQuery query];
	self.query.outFields = [NSArray arrayWithObjects:kRouteIDField, nil];
	self.query.orderByFields = @[[NSString stringWithFormat:@"%@ ASC", kRouteIDField]];
	self.query.where = [NSString stringWithFormat:@"%@ IS NOT NULL", kRouteIDField];

	self.queryTask = [AGSQueryTask queryTaskWithURL:[NSURL URLWithString:kFeatureLayerURLGame]];
	self.queryTask.delegate = self;
	[self.queryTask executeWithQuery:self.query];
	
	[self.textField becomeFirstResponder];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:@"UITextFieldTextDidChangeNotification" object:self.textField];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - AGSQueryTaskDelegate

- (void)queryTask:(AGSQueryTask *)queryTask operation:(NSOperation *)op didExecuteWithFeatureSetResult:(AGSFeatureSet *)featureSet
{
	NSMutableArray *array = [NSMutableArray array];
	
	for (AGSGraphic *feature in featureSet.features)
	{
		NSString *route_id = [feature attributeAsStringForKey:kRouteIDField];
//		NSString *route_name = [feature attributeAsStringForKey:kRouteNameField];
		NSDictionary *route = @{kRouteIDField: route_id};
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
		
	self.dataArray = [NSArray arrayWithArray:array];
	
	[self.tableView reloadData];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
	NSDictionary *dict = ([self.textField.text isEqualToString:@""]) ? self.dataArray[indexPath.row] : self.filteredArray[indexPath.row];
	
    cell.textLabel.text = dict[kRouteIDField];
    cell.detailTextLabel.text = dict[kRouteNameField];
	
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	NSDictionary *dict = ([self.textField.text isEqualToString:@""]) ? self.dataArray[indexPath.row] : self.filteredArray[indexPath.row];

	OGRouteSelectionViewController *routeSelectionViewController = (OGRouteSelectionViewController*)((UINavigationController*)self.presentingViewController).viewControllers[1];
	[routeSelectionViewController selectRouteWithID:dict[kRouteIDField]];
	[routeSelectionViewController dismissViewControllerWithFlipStyle:MPFlipStyleDirectionBackward completion:nil];
}


#pragma mark - Action methods

- (IBAction)cancelButtonPressed:(id)sender
{
	[self.presentingViewController dismissViewControllerWithFlipStyle:MPFlipStyleDirectionBackward completion:NULL];
}

#pragma mark - Notifications

- (void)textDidChange :(NSNotification *)notif
{
	[self.filteredArray removeAllObjects];
	
	NSString *searchString = self.textField.text;
	NSLog(@"%@", searchString);	
	
	NSIndexSet *indice = [self.dataArray indexesOfObjectsPassingTest:^BOOL(NSDictionary *dict, NSUInteger idx, BOOL *stop)
						  {
							  return ([dict[kRouteIDField] rangeOfString:searchString options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch].location != NSNotFound);
						  }];
	
	[self.filteredArray addObjectsFromArray:[self.dataArray objectsAtIndexes:indice]];
	
	[self.tableView reloadData];
	
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
