//
//  OGEditorViewController.m
//  Ori-Gami
//
//  Created by Benni on 09.05.13.
//  Copyright (c) 2013 Ifgi. All rights reserved.
//

#import "OGEditorViewController.h"
#import "MPFoldTransition.h"


@interface OGEditorViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation OGEditorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	
}



- (IBAction)closeButtonPressed:(id)sender
{
	[self.presentingViewController dismissViewControllerWithFoldStyle:MPFoldStyleCubic | MPFoldStyleHorizontal completion:^(BOOL finished) {
		
	}];
}


- (void)viewDidUnload
{
	[self setWebView:nil];
	[super viewDidUnload];
}


@end
