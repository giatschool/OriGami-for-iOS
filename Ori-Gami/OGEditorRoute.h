//
//  OGEditorRoute.h
//  Ori-Gami
//
//  Created by Benni on 11.05.13.
//  Copyright (c) 2013 Ifgi. All rights reserved.
//

#import "OGRoute.h"

@interface OGEditorRoute : OGRoute

- (OGTask*)objectAtIndexedSubscript:(NSUInteger)idx;

@end
