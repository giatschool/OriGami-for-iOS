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
#import "MPFlipTransition.h"

@interface OGRouteSelectionViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

@implementation OGRouteSelectionViewController


#pragma mark - UIViewController

/**
 When the view appeared, make the keyboard visible.
 **/
- (void)viewDidAppear:(BOOL)animated
{
	[self.textField becomeFirstResponder];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (![self.textField.text isEqualToString:@""])
	{
		[self performSegueWithIdentifier:@"startGameSegue" sender:self];
	}
	
	return YES;
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

#pragma mark - Public methods

- (void)selectRouteWithID:(NSString*)routeID
{
	self.textField.text = routeID;
}

@end
