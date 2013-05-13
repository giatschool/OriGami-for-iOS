//
//  UIAlertView+Extensions.h
//  BDBrightKitTest
//
//  Created by Benni on 08.01.13.
//  Copyright (c) 2013 Brightside-Development. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BDDismissalBlock)(NSInteger buttonIndex);

/**
 Block based additions for UIAlertView, just set the dismissal block and react to the pressed button.
 **/
@interface UIAlertView (Extensions) <UIAlertViewDelegate>

+ (id)alertViewWithTitle:(NSString *)title
				 message:(NSString *)message
	   cancelButtonTitle:(NSString *)cancelButtonTitle
	   otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@property (copy, nonatomic) BDDismissalBlock dismissalBlock;

@end
