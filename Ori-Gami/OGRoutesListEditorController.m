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
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) NSMutableArray *filteredArray;

@end


@implementation OGRoutesListEditorController


#pragma mark - UIViewController

- (void)viewDidLoad
{
	self.filteredArray = [NSMutableArray array];
	self.editButton.enabled = self.canEdit;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:@"UITextFieldTextDidChangeNotification" object:self.textField];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if ([self.textField.text isEqualToString:@""])
	{
		return self.dataArray.count;
	}
	else
	{
		return self.filteredArray.count;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
	OGEditorRoute *route = ([self.textField.text isEqualToString:@""]) ? self.dataArray[indexPath.row] : self.filteredArray[indexPath.row];
    cell.detailTextLabel.text = route.routeID;
    cell.textLabel.text = route.name;
	
    return cell;
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
				OGEditorRoute *route = self.dataArray[indexPath.row];
				[self.delegate routesListController:self didDeleteRoute:route];
								
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
			[self.delegate routesListController:self didSelectRoute:self.dataArray[indexPath.row]];
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


#pragma mark - Notifications

- (void)textDidChange :(NSNotification *)notification
{
	[self.filteredArray removeAllObjects];
	
	NSString *searchString = self.textField.text;
	
	NSIndexSet *indice = [self.dataArray indexesOfObjectsPassingTest:^BOOL(OGEditorRoute *route, NSUInteger idx, BOOL *stop)
						  {
							  return ([route.routeID rangeOfString:searchString options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch].location != NSNotFound);
						  }];
	
	[self.filteredArray addObjectsFromArray:[self.dataArray objectsAtIndexes:indice]];
	
	[self.tableView reloadData];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
