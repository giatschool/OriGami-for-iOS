//
//  UIActionSheet+Extensions.h
//  Reader
//
//  Created by Benni on 08.01.13.
//  Copyright (c) 2013 Brightside Development. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BDDismissalBlock)(NSInteger buttonIndex);

/**
 Block based additions for UIActionSheet, just set the dismissal block and react to the pressed button.
 **/
@interface UIActionSheet (Extensions) <UIActionSheetDelegate>

+ (id)actionSheetWithTitle:(NSString *)title
		  cancelButtonTitle:(NSString *)cancelButtonTitle
	 destructiveButtonTitle:(NSString *)destructiveButtonTitle
		  otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@property (copy, nonatomic) BDDismissalBlock dismissalBlock;

@end