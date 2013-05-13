//
//  OGWaypointRenderer.m
//  Ori-Gami
//
//  Created by Benni on 13.05.13.
//  Copyright (c) 2013 Ifgi. All rights reserved.
//

#import "OGWaypointRenderer.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+Extensions.h"

@implementation OGWaypointRenderer

- (AGSSymbol *)symbolForGraphic:(AGSGraphic *)graphic timeExtent:(AGSTimeExtent *)timeExtent
{
	NSString *number = [graphic attributeAsStringForKey:kWaypointIDField];
	UILabel *label = [self getLabelWithString:number];
	UIImage *image = [label screenshot];
	
	AGSPictureMarkerSymbol *pictureSymbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:image];
	
	return pictureSymbol;
}

- (UILabel*)getLabelWithString:(NSString*)number
{
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)];
	label.text = number;
	label.textColor = [UIColor whiteColor];
	label.textAlignment = NSTextAlignmentCenter;
	label.backgroundColor = [UIColor blueColor];
	label.font = [UIFont systemFontOfSize:30.0];

	label.layer.borderColor = [UIColor whiteColor].CGColor;
	label.layer.borderWidth = 5.0;
	label.layer.cornerRadius = 25.0;
	
	return label;
}


@end
