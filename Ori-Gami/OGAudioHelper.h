//
//  BDAudioHelper.h
//  BDBrightKitTest
//
//  Created by Benni on 08.01.13.
//  Copyright (c) 2013 Brightside-Development. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OGAudioHelper : NSObject

+ (void)playMP3SoundWithName:(NSString*)name error:(void (^)(NSError *error))error;

@end
