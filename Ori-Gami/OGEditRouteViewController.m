//
//  OGEditRouteViewController.m
//  Ori-Gami
//
//  Created by Benni on 10.05.13.
//  Copyright (c) 2013 Ifgi. All rights reserved.
//

#import "OGEditRouteViewController.h"
#import "NSString+RandomString.h"

@interface OGEditRouteViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@property (nonatomic, strong) NSString *mailAddress;

@end

@implementation OGEditRouteViewController


#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.mailAddress = @"";
	
	if (self.isAddingNewRoute)
	{
		self.route.routeID = [NSString randomAlphanumericStringWithLength:5];
	}
	else
	{
		self.navigationItem.leftBarButtonItem = nil;
	}
	
	self.saveButton.enabled = !self.isAddingNewRoute;
	self.title = [NSString stringWithFormat:@"Route: %@", self.route.routeID];
	self.nameTextField.text = self.route.name;
	[self.nameTextField becomeFirstResponder];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:@"UITextFieldTextDidChangeNotification" object:self.nameTextField];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	if ([textField isEqual:self.nameTextField])
	{
		self.route.name = textField.text;
	}
	
	if ([textField isEqual:self.emailTextField])
	{
		self.mailAddress = textField.text;
	}
}


#pragma mark - Private Methods




#pragma mark - Action methods

- (IBAction)saveButtonPressed:(id)sender
{
	if ([self.mailAddress isEqualToString:@""])
	{
		[self.delegate editRouteController:self didSaveRoute:self.route];
	}
	else
	{
		
	}
}

- (IBAction)cancelButtonPressed:(id)sender
{
	[self.delegate editRouteController:self didCancelRoute:self.route];
}


#pragma mark - Notifications

- (void)textDidChange :(NSNotification *)notification
{
	self.saveButton.enabled = !([self.nameTextField.text isEqualToString:@""]);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
