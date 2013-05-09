//
//  OGRouteSelectionViewController.m
//  Ori-Gami
//
//  Created by Benni on 20.02.13.
//  Copyright (c) 2013 Ifgi. All rights reserved.
//

#import "OGRouteSelectionViewController.h"
#import "OGGameViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "OGRouteCell.h"
#import "MPFlipTransition.h"
#import <ArcGIS/ArcGIS.h>

@interface OGRouteSelectionViewController () <UITextFieldDelegate, AGSQueryTaskDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UILabel *waitlabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSMutableArray *filteredArray;
@property (nonatomic, strong) AGSQuery *query;
@property (nonatomic, strong) AGSQueryTask *queryTask;

@end

@implementation OGRouteSelectionViewController


#pragma mark - UIViewController

/**
 When the view appeared, query all routes and show them in the tableView.
 **/
- (void)viewDidAppear:(BOOL)animated
{
	self.dataArray = [NSArray array];
	self.filteredArray = [NSMutableArray array];
	
	self.query = [AGSQuery query];
	self.query.outFields = [NSArray arrayWithObjects:kRouteIDField, nil];
	self.query.orderByFields = @[[NSString stringWithFormat:@"%@ ASC", kRouteIDField]];
	self.query.where = [NSString stringWithFormat:@"%@ IS NOT NULL", kRouteIDField];
	
	self.queryTask = [AGSQueryTask queryTaskWithURL:[NSURL URLWithString:kFeatureLayerURLGame]];
	self.queryTask.delegate = self;
	[self.queryTask executeWithQuery:self.query];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:@"UITextFieldTextDidChangeNotification" object:self.textField];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	
	[UIView animateWithDuration:0.5 animations:^{

		CGRect frame = self.searchButton.frame;
		
		if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
		{
			frame.origin.x += 150.0;
		}
		else
		{
			frame.origin.x += 150.0;
		}
		
		self.searchButton.frame = frame;
		self.textField.alpha = 0.0;
	}];
	
	return YES;
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


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
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
	
	self.waitlabel.hidden = YES;
	[self.activityIndicator stopAnimating];
}

- (void)queryTask:(AGSQueryTask *)queryTask operation:(NSOperation *)op didFailWithError:(NSError *)error
{
	OGLog(error.localizedDescription);
}


#pragma mark - Segue Handling

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"startGameSegue"])
	{
		OGGameViewController *controller = (OGGameViewController*)segue.destinationViewController;
		controller.routeID = self.textField.text;
		
	}
}


#pragma mark - Private Methods

- (IBAction)cancelButtonPressed:(id)sender
{
	[self.navigationController popViewControllerWithFlipStyle:MPFlipStyleDirectionBackward];
}

- (IBAction)searchButtonPressed:(id)sender
{
	[self.textField becomeFirstResponder];
	
	[UIView animateWithDuration:0.5 animations:^{
		
		CGRect frame = self.searchButton.frame;
		
		if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
		{
			frame.origin.x -= 150.0;
		}
		else
		{
			frame.origin.x -= 150.0;
		}
		
		self.searchButton.frame = frame;
		self.textField.alpha = 0.0;
	}];
	
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



- (void)viewDidUnload {
	[self setWaitlabel:nil];
	[self setActivityIndicator:nil];
	[super viewDidUnload];
}
@end
