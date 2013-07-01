//
//  OGRouteSelectionViewController.m
//  Ori-Gami
//
//  Created by Benni on 20.02.13.
//  Copyright (c) 2013 Ifgi. All rights reserved.
//

#import "OGRoutesListGameController.h"
#import "OGGameViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "OGRouteCell.h"
#import "OGGameRoute.h"
#import "MPFlipTransition.h"
#import <ArcGIS/ArcGIS.h>

@interface OGRoutesListGameController () <UITextFieldDelegate, AGSQueryTaskDelegate>
@property (weak, nonatomic) IBOutlet UIButton *searchButton;


@end

@implementation OGRoutesListGameController


#pragma mark - UIViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
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


#pragma mark - Segue Handling

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"startGameSegue"])
	{
		OGGameViewController *controller = (OGGameViewController*)segue.destinationViewController;
		
		if ([self.textField.text isEqualToString:@""])
		{
			controller.routeID = self.dataArray[self.tableView.indexPathForSelectedRow.row][kRouteIDField];
		}
		else
		{
			controller.routeID = self.filteredArray[self.tableView.indexPathForSelectedRow.row][kRouteIDField];
		}
		
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
		self.textField.alpha = 1.0;
	}];
	
}


@end
