//
//  OGViewController.m
//  Ori-Gami
//
//  Created by Benni on 20.02.13.
//  Copyright (c) 2013 Ifgi. All rights reserved.
//

#import "OGMainMenuViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface OGMainMenuViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *paperBackgroundImageView;
@end

@implementation OGMainMenuViewController

#pragma mark - View Lifecycle

/**
 The paper background gets a nice shadow.
 **/
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.paperBackgroundImageView.layer.shadowOpacity = 1.0;
	self.paperBackgroundImageView.layer.shadowOffset = CGSizeMake(0.0, 0.0);
	self.paperBackgroundImageView.layer.shadowRadius = 20.0;
	self.paperBackgroundImageView.layer.backgroundColor = [[UIColor blackColor] CGColor];
	self.paperBackgroundImageView.layer.shadowPath = [[UIBezierPath bezierPathWithRect:self.paperBackgroundImageView.bounds] CGPath];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}




@end
