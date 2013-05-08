//
//  BDAudioHelper.m
//  BDBrightKitTest
//
//  Created by Benni on 08.01.13.
//  Copyright (c) 2013 Brightside-Development. All rights reserved.
//

#import "OGAudioHelper.h"
#import <AudioToolbox/AudioToolbox.h>

@interface OGAudioHelper ()

@end

@implementation OGAudioHelper

+ (void)playMP3SoundWithName:(NSString*)name error:(void (^)(NSError *error))error
{
	[OGAudioHelper playSoundWithName:name andFileType:@"mp3" error:error];
}

+ (void)playSoundWithName:(NSString*)name andFileType:(NSString*)fileType error:(void (^)(NSError *error))error
{
	NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:name ofType:fileType];
	
    if ([[NSFileManager defaultManager] fileExistsAtPath:soundFilePath])
    {
		SystemSoundID audioEffect;
		
        NSURL *pathURL = [NSURL fileURLWithPath:soundFilePath];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &audioEffect);
        AudioServicesPlaySystemSound(audioEffect);
    }
    else
    {
		NSError *IOError = [[NSError alloc] initWithDomain:nil code:8 userInfo:[NSDictionary dictionaryWithObject:NSLocalizedString(@"ioErrorString", @"") forKey:NSLocalizedDescriptionKey]];
		error(IOError);
	}
}

@end
