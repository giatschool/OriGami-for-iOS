//
//  OGSmileyView.m
//
//  Created by Benni on 21.08.12.
//  Copyright (c) 2012 bb. All rights reserved.
//

#import "OGSmileyView.h"
#import <QuartzCore/QuartzCore.h>

#define DEFAULT_START_Y (HALF + EIGHTH)
#define DEFAULT_END_Y (HALF + QUARTER)
#define HALF self.bounds.size.width / 2.0
#define QUARTER self.bounds.size.width / 4.0
#define EIGHTH self.bounds.size.width / 8.0
#define TENTH self.bounds.size.width / 10.0

@interface OGSmileyView ()
@property (nonatomic, assign, readwrite) CGFloat mouthStartY;
@property (nonatomic, assign, readwrite) CGFloat mouthEndY;
@end

@implementation OGSmileyView

#pragma mark - Initialization

/**
 Initializer via code. Calls the common initializer method.
 **/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
	
    if (self)
	{
		[self commonInit];
    }
	
    return self;
}

/**
 Initializer via interface builder. Calls the common initializer method.
 **/

-(id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	
    if (self)
	{
		[self commonInit];
    }
	
    return self;
}

/**
 The common initializer method. Sets default values for mouth start/end height. 
 **/
- (void)commonInit
{
	_mouthStartY = 125.5;
	_mouthEndY = 180.5;
	
	self.clipsToBounds = NO;
	self.backgroundColor = [UIColor clearColor];
}

#pragma mark - Private methods

/**
 Draw the smiley according to the current values
 **/
-(void)drawRect:(CGRect)rect
{
	//// General Declarations
	CGContextRef context = UIGraphicsGetCurrentContext();

	CGFloat eyeWidth = TENTH / 2.0;
	CGFloat eyeHeight = TENTH * 2.0;

	//// Color Declarations
	UIColor* black = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
	UIColor *yellow = [UIColor colorWithHue:self.value / 3.6 saturation:1.0 brightness:1.0 alpha:1.0];
	
	//// Shadow Declarations
	CGColorRef shadow5 = black.CGColor;
	CGSize shadow5Offset = CGSizeMake(0.0, 0.0);
	CGFloat shadow5BlurRadius = 5.0;
	CGColorRef shadow3 = black.CGColor;
	CGSize shadow3Offset = CGSizeMake(0.0, 0.0);
	CGFloat shadow3BlurRadius = 3.0;
	
	//// Underground Drawing
	UIBezierPath* undergroundPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(self.bounds, shadow5BlurRadius, shadow5BlurRadius)];
	CGContextSaveGState(context);
	CGContextSetShadowWithColor(context, shadow5Offset, shadow5BlurRadius, shadow5);
	[yellow setFill];
	[undergroundPath fill];
	CGContextRestoreGState(context);
	
	[[UIColor blackColor] setStroke];
	undergroundPath.lineWidth = 1;
	[undergroundPath stroke];

	//// Left Eye Drawing
	UIBezierPath* leftEyePath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(HALF - EIGHTH - eyeWidth, QUARTER, eyeWidth, eyeHeight)];
	[black setFill];
	[leftEyePath fill];
	
	CGContextSaveGState(context);
	CGContextSetShadowWithColor(context, shadow3Offset, shadow3BlurRadius, shadow3);
	[black setStroke];
	leftEyePath.lineWidth = 1;
	[leftEyePath stroke];
	CGContextRestoreGState(context);
	
	//// Right eye Drawing
	UIBezierPath* rightEyePath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(HALF + EIGHTH, QUARTER, eyeWidth, eyeHeight)];
	[black setFill];
	[rightEyePath fill];
	
	CGContextSaveGState(context);
	CGContextSetShadowWithColor(context, shadow3Offset, shadow3BlurRadius, shadow3);
	[black setStroke];
	rightEyePath.lineWidth = 1;
	[rightEyePath stroke];
	CGContextRestoreGState(context);
	
	//// Mouth Drawing
	UIBezierPath* mouthPath = [UIBezierPath bezierPath];
	[mouthPath moveToPoint: CGPointMake(QUARTER, self.mouthStartY)];
	[mouthPath addCurveToPoint: CGPointMake(HALF + QUARTER, self.mouthStartY) controlPoint1: CGPointMake(HALF, self.mouthEndY) controlPoint2: CGPointMake(HALF + QUARTER, self.mouthStartY)];
	CGContextSaveGState(context);
	CGContextSetShadowWithColor(context, shadow3Offset, shadow3BlurRadius, shadow3);
	[[UIColor blackColor] setStroke];
	mouthPath.lineWidth = self.bounds.size.width * 0.015;
	[mouthPath stroke];
	CGContextRestoreGState(context);
}

#pragma mark - Public Methods

/**
 Set the smiley to a neutral position
 **/
- (void)reset
{
	self.value = 0.5;
}

/**
 Custom setter. If the value is smaller than 0 it is set to 0 and if it's greater than 1 it is set to 1.
 The values for mouth start height and mouth end height are also updated.
 **/
- (void)setValue:(CGFloat)value
{
	_value = (value < 0.0) ? 0.0 : (value > 1.0) ? 1.0 : value;
		
	CGFloat difference = DEFAULT_END_Y - DEFAULT_START_Y;
		
	self.mouthStartY = DEFAULT_END_Y - (difference * self.value);
	self.mouthEndY = DEFAULT_START_Y + (difference * self.value);
	
	[self setNeedsDisplay];
}

@end
