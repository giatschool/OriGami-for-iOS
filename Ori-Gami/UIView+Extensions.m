//
//  UIView+Extensions.m
//  BDBrightKitTest
//
//  Created by Benni on 20.03.13.
//  Copyright (c) 2013 Brightside-Development. All rights reserved.

#import "UIView+Extensions.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (Extensions)

- (UIImage *)screenshot
{
	UIImage *img;
	UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, [[UIScreen mainScreen] scale]);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	{
		if ([self isKindOfClass:[UIScrollView class]])
		{
			CGPoint contentOffset = [(UIScrollView*)self contentOffset];
			CGContextTranslateCTM(ctx, 0, -contentOffset.y);
		}
		
		[self.layer renderInContext:ctx];
		img = UIGraphicsGetImageFromCurrentImageContext();
	}
	UIGraphicsEndImageContext();
	
    return img;
}

@end
