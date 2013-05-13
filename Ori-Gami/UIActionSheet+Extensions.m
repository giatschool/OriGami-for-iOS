//
//  UIActionSheet+Extensions.m
//  Reader
//
//  Created by Benni on 08.01.13.
//  Copyright (c) 2013 Brightside Development. All rights reserved.
//

#import "UIActionSheet+Extensions.h"
#import <objc/runtime.h>

static NSString *kDismissalActionKey = @"dismissalAction";

@implementation UIActionSheet (Extensions)

+ (id)actionSheetWithTitle:(NSString *)title
		 cancelButtonTitle:(NSString *)cancelButtonTitle
	destructiveButtonTitle:(NSString *)destructiveButtonTitle
		  otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
	UIActionSheet *actionSheet = [[self alloc] initWithTitle:title
													delegate:nil
										   cancelButtonTitle:cancelButtonTitle
									  destructiveButtonTitle:destructiveButtonTitle
										   otherButtonTitles:otherButtonTitles, nil];
	actionSheet.delegate = actionSheet;
    return actionSheet;
}

- (void)setDismissalBlock:(BDDismissalBlock)dismissalBlock
{
	objc_setAssociatedObject(self, (__bridge const void *)kDismissalActionKey, nil, OBJC_ASSOCIATION_COPY);
    objc_setAssociatedObject(self, (__bridge const void *)kDismissalActionKey, dismissalBlock, OBJC_ASSOCIATION_COPY);
}

- (BDDismissalBlock)dismissalBlock
{
	return objc_getAssociatedObject(self, (__bridge const void *)kDismissalActionKey);
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (self.dismissalBlock) self.dismissalBlock(buttonIndex);
    self.dismissalBlock = nil;
}

@end