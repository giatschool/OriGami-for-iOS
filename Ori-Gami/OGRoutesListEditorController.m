//
//  OGRoutesListViewController.m
//  Ori-Gami
//
//  Created by Benni on 10.05.13.
//  Copyright (c) 2013 Ifgi. All rights reserved.
//

#import "OGRoutesListEditorController.h"
#import "OGRouteCell.h"
#import "OGEditorRoute.h"
#import "UIActionSheet+Extensions.h"


@interface OGRoutesListEditorController () <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UIBarButtonItem *editButton;

@end


@implementation OGRoutesListEditorController


#pragma mark - UIViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.editButton.enabled = self.canEdit;
}


#pragma mark - Table view delegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return self.canEdit;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		NSString *title = @"Wirklich löschen?";
		NSString *cancel = @"Abbrechen";
		NSString *delete = @"Löschen";
		
		UIActionSheet *actionSheet = [UIActionSheet actionSheetWithTitle:title cancelButtonTitle:cancel destructiveButtonTitle:delete otherButtonTitles:nil];
		actionSheet.dismissalBlock = ^(NSInteger buttonIndex)
		{
			if (self.canEdit && buttonIndex == 1)
			{
				[self.delegate routesListController:self didDeleteRouteWithID:self.dataArray[indexPath.row][kRouteIDField]];
								
				[self.dataArray removeObjectAtIndex:indexPath.row];
				[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
			}
		};
		
		[actionSheet showInView:self.view];
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	NSString *title = @"Route laden? Bestehende Daten sind gesichert.";
	NSString *cancel = @"Abbrechen";
	NSString *load = @"Laden";

	UIActionSheet *actionSheet = [UIActionSheet actionSheetWithTitle:title cancelButtonTitle:cancel destructiveButtonTitle:nil otherButtonTitles:load, nil];
	actionSheet.dismissalBlock = ^(NSInteger buttonIndex)
	{
		if (buttonIndex == 0)
		{
			[self.delegate routesListController:self didSelectRouteWithID:self.dataArray[indexPath.row][kRouteIDField]];
		}
	};
	
	[actionSheet showInView:self.view];
}


#pragma mark - Action Methods

- (IBAction)editButtonPressed:(id)sender
{
	[self.tableView setEditing:!self.tableView.isEditing animated:YES];
	[self setEditing:!self.isEditing animated:YES];
	
	UIBarButtonItem *editButton = (UIBarButtonItem*)sender;
	
	if (self.isEditing)
	{
		editButton.style = UIBarButtonItemStyleDone;
		editButton.title = @"Done";
	}
	else
	{
		editButton.title = @"Edit";
		editButton.style = UIBarButtonItemStyleBordered;
	}
}


@end
