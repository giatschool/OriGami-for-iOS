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
@property (weak, nonatomic) IBOutlet UIImageView *paperBackgroundImageView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

@implementation OGRouteSelectionViewController

/**
 The paper background gets a nice shadow.
 The textfield gets a debug route id (Mannheim) as a default value.
 **/
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.paperBackgroundImageView.layer.shadowOpacity = 1.0;
	self.paperBackgroundImageView.layer.shadowOffset = CGSizeMake(0.0, 0.0);
	self.paperBackgroundImageView.layer.shadowRadius = 20.0;
	self.paperBackgroundImageView.layer.backgroundColor = [[UIColor blackColor] CGColor];
	self.paperBackgroundImageView.layer.shadowPath = [[UIBezierPath bezierPathWithRect:self.paperBackgroundImageView.bounds] CGPath];

	self.textField.text = kDebugRouteID;
}

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
