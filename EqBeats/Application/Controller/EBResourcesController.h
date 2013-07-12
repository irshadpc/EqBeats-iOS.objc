//
//  EBResourcesController.h
//  EqBeats
//
//  Created by Tyrone Trevorrow on 2/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EBTrack.h"

extern NSUInteger EBDeviceSystemMajorVersion();
@class EBImageView;
@interface EBResourcesController : NSObject

+ (void) setImageForImageView: (EBImageView*) imageView
                        track: (EBTrack*) track
                      quality: (EBTrackArtQuality) quality;

+ (UIImage*) placeholderImageForQuality: (EBTrackArtQuality) quality;
+ (UIImage*) noArtworkImageForQuality: (EBTrackArtQuality) quality;

#pragma mark - Paths

+ (NSURL*) applicationSupportPath;
+ (NSURL*) libraryPath;
+ (NSURL*) documentsPath;
+ (NSURL*) cachePath;
+ (NSURL*) applicationBinaryPath;

@end
