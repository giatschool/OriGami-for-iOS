//
//  OGEndGameViewController.m
//  Ori-Gami
//
//  Created by Benni on 13.03.13.
//  Copyright (c) 2013 Ifgi. All rights reserved.
//

#import "OGEndGameViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MPFlipTransition.h"
#import "OGRoute.h"

@interface OGEndGameViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *paperBackgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation OGEndGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	
	int minutes = self.route.time / 60;
	int seconds = (int)self.route.time % 60;
	
	self.label.text = [NSString stringWithFormat:@"Du hast %i Minuten und %i Sekunden gebraucht!", minutes, seconds];

	self.paperBackgroundImageView.layer.shadowOpacity = 1.0;
	self.paperBackgroundImageView.layer.shadowOffset = CGSizeMake(0.0, 0.0);
	self.paperBackgroundImageView.layer.shadowRadius = 20.0;
	self.paperBackgroundImageView.layer.backgroundColor = [[UIColor blackColor] CGColor];
	self.paperBackgroundImageView.layer.shadowPath = [[UIBezierPath bezierPathWithRect:self.paperBackgroundImageView.bounds] CGPath];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)mainMenuButtonPressed:(id)sender
{
	[self.navigationController popToRootViewControllerWithFlipStyle:MPFlipStyleDirectionBackward];
}

- (void)viewDidUnload {
	[self setLabel:nil];
	[super viewDidUnload];
}
@end
