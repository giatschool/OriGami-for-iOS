//
//  NSString+RandomString.m
//  Ori-Gami
//
//  Created by Benni on 12.05.13.
//  Copyright (c) 2013 Ifgi. All rights reserved.
//

#import "NSString+RandomString.h"

@implementation NSString (RandomString)

+ (NSString *)randomAlphanumericStringWithLength:(NSInteger)length
{
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
	
    for (int i = 0; i < length; i++)
	{
        [randomString appendFormat:@"%C", [letters characterAtIndex:arc4random() % [letters length]]];
    }
	
    return randomString;
}

@end