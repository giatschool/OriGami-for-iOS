//
//  OGEditorRoute.h
//  Ori-Gami
//
//  Created by Benni on 11.05.13.
//  Copyright (c) 2013 Ifgi. All rights reserved.
//

#import "OGGameRoute.h"

@interface OGEditorRoute : OGGameRoute

+ (instancetype)editorRouteWithName:(NSString*)name id:(NSString*)idCode;

@end
