//
//  OGEndGameViewController.m
//  Ori-Gami
//
//  Created by Benni on 13.03.13.
//  Copyright (c) 2013 Ifgi. All rights reserved.
//

#import "OGEndGameViewController.h"
#import "MPFlipTransition.h"
#import "OGGameRoute.h"

@interface OGEndGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation OGEndGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	int minutes = self.route.time / 60;
	int seconds = (int)self.route.time % 60;
	
	self.label.text = [NSString stringWithFormat:@"Du hast %i Minuten und %i Sekunden gebraucht!", minutes, seconds];
}


- (IBAction)mainMenuButtonPressed:(id)sender
{
	[self.navigationController popToRootViewControllerWithFlipStyle:MPFlipStyleDirectionBackward];
}

- (void)viewDidUnload
{
	[self setLabel:nil];
	
	[super viewDidUnload];
}

@end
