//
//  OGEditorRoute.m
//  Ori-Gami
//
//  Created by Benni on 11.05.13.
//  Copyright (c) 2013 Ifgi. All rights reserved.
//

#import "OGEditorRoute.h"

@implementation OGEditorRoute

+ (instancetype)editorRouteWithName:(NSString*)name id:(NSString*)idCode
{
	OGEditorRoute *route = [OGEditorRoute new];
	route.name = name;
	route.routeID = idCode;
	
	return route;
}



@end
