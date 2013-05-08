//
//  OGLog.m
//  Ori-Gami
//
//  Created by Benni on 13.03.13.
//  Copyright (c) 2013 Ifgi. All rights reserved.
//

#import "OGLog.h"

void OGLog(id object)
{
	NSString *sourceString = [[NSThread callStackSymbols] objectAtIndex:1];
	NSCharacterSet *separatorSet = [NSCharacterSet characterSetWithCharactersInString:@" -[]+?.,"];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[sourceString  componentsSeparatedByCharactersInSet:separatorSet]];
    [array removeObject:@""];
	
	NSString *string = [NSString stringWithFormat:@"[%@ %@] - %@", [array objectAtIndex:4], [array objectAtIndex:5], object];
	
	NSLog(@"%@", string);
}
