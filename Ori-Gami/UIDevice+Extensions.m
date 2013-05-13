//
//  UIDevice+Extensions.m
//  BDBrightKitTest
//
//  Created by Benni on 04.04.13.
//  Copyright (c) 2013 Brightside-Development. All rights reserved.
//

#import "UIDevice+Extensions.h"

@implementation UIDevice (Extensions)

+ (BOOL)iPad
{
	return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

+ (BOOL)isInPortraitOrientation
{
	return UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]);
}

@end
