//
//  OGEditWaypointViewController.m
//  Ori-Gami
//
//  Created by Benni on 09.05.13.
//  Copyright (c) 2013 Ifgi. All rights reserved.
//

#import "OGEditWaypointViewController.h"
#import "OGTask.h"



@interface OGEditWaypointViewController ()
@property (nonatomic, weak) IBOutlet UITextView *textView;
@end

@implementation OGEditWaypointViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.textView.text = self.task.taskDescription;
}


- (void)setTask:(OGTask *)task
{
	if (task)
	{
		_task = task;
		
		self.textView.text = self.task.taskDescription;
		self.title = [NSString stringWithFormat:@"%i", self.task.waypointNumber];
	}
}

@end
