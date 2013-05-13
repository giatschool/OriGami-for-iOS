//
//  UIAlertView+Extensions.m
//  BDBrightKitTest
//
//  Created by Benni on 08.01.13.
//  Copyright (c) 2013 Brightside-Development. All rights reserved.
//

#import "UIAlertView+Extensions.h"
#import <objc/runtime.h>

static NSString *kDismissalActionKey = @"dismissalAction";

@implementation UIAlertView (Extensions)

+ (id)alertViewWithTitle:(NSString *)title
				 message:(NSString *)message
	   cancelButtonTitle:(NSString *)cancelButtonTitle
	   otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
														message:message
													   delegate:nil
											  cancelButtonTitle:cancelButtonTitle
											  otherButtonTitles:otherButtonTitles, nil];
	alertView.delegate = alertView;
    return alertView;
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (self.dismissalBlock) self.dismissalBlock(buttonIndex);
    self.dismissalBlock = nil;
}


@end
