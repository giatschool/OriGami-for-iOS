//
//  OGHelpViewController.m
//  Ori-Gami
//
//  Created by Benni on 20.02.13.
//  Copyright (c) 2013 Ifgi. All rights reserved.
//

#import "OGHelpViewController.h"
#import "MPFlipTransition.h"

@interface OGHelpViewController ()

@end

@implementation OGHelpViewController


- (IBAction)closeButtonPressed:(id)sender
{
	[self.navigationController popToRootViewControllerWithFlipStyle:MPFlipStyleDirectionBackward];
}




@end
