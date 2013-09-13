//
//  OGMenuBaseViewController.m
//  Ori-Gami
//
//  Created by Benni on 09.05.13.
//  Copyright (c) 2013 Ifgi. All rights reserved.
//

#import "OGMenuBaseViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface OGMenuBaseViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *paperBackgroundImageView;

@end

@implementation OGMenuBaseViewController

#pragma mark - UIViewController

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
}

/**
 Setting the shadow path later, because of device orientation
 **/
- (void)viewDidAppear:(BOOL)animated
{
	self.paperBackgroundImageView.layer.shadowPath = [[UIBezierPath bezierPathWithRect:self.paperBackgroundImageView.bounds] CGPath];
}

/**
 Handling rotation changes to update the paper view's shadow correctly
 **/
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	NSLog(@"%s", __func__);

	CGRect fromRect = self.paperBackgroundImageView.bounds;
	CGRect toRect = self.paperBackgroundImageView.bounds;
	fromRect.size.height = toRect.size.width;
	fromRect.size.width = toRect.size.height;
	
	CABasicAnimation *theAnimation = [CABasicAnimation animationWithKeyPath:@"shadowPath"];
	theAnimation.duration = duration;
	theAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	theAnimation.fromValue = (id)[UIBezierPath bezierPathWithRect:fromRect].CGPath;
	theAnimation.toValue = (id)[UIBezierPath bezierPathWithRect:toRect].CGPath;
	[self.paperBackgroundImageView.layer addAnimation:theAnimation forKey:@"shadowPath"];
	
	self.paperBackgroundImageView.layer.shadowPath = [UIBezierPath bezierPathWithRect:toRect].CGPath;
}

@end
