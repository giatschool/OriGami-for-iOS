//
//  OGEditorRoute.m
//  Ori-Gami
//
//  Created by Benni on 11.05.13.
//  Copyright (c) 2013 Ifgi. All rights reserved.
//

#import "OGEditorRoute.h"

@implementation OGEditorRoute




#pragma mark - Subscripting

- (OGTask*)objectAtIndexedSubscript:(NSUInteger)idx
{
	return _tasks[idx];
}



@end
