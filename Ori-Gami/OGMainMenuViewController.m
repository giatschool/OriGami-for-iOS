//
//  OGViewController.m
//  Ori-Gami
//
//  Created by Benni on 20.02.13.
//  Copyright (c) 2013 Ifgi. All rights reserved.
//

#import "OGMainMenuViewController.h"
#import "MPFoldTransition.h"
#import "OGEditorViewController.h"

@interface OGMainMenuViewController ()

@end

@implementation OGMainMenuViewController

#pragma mark - View Lifecycle


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (IBAction)editorButtonPressed:(id)sender
{
	OGEditorViewController *editorViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"editorViewController"];

	[self presentViewController:editorViewController foldStyle:MPFoldStyleCubic | MPFoldStyleUnfold completion:^(BOOL finished) {
		
	}];
}

@end
