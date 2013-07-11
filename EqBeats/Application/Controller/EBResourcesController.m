//
//  EBResourcesController.m
//  EqBeats
//
//  Created by Tyrone Trevorrow on 2/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import "EBResourcesController.h"
#import "UIImageView+WebCache.h"

NSUInteger EBDeviceSystemMajorVersion() {
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    return _deviceSystemMajorVersion;
}

@implementation EBResourcesController

+ (void) setImageForImageView: (UIImageView*) imageView
                        track: (EBTrack*) track
                      quality: (EBTrackArtQuality) quality
{
    if ([track artURLAtQuality: quality] == nil) {
        [imageView setImage: [self noArtworkImageForQuality: quality]];
    } else {
        __weak UIImageView *weakImageView = imageView;
        [imageView setImageWithURL: [track artURLAtQuality: quality]
                  placeholderImage: [self placeholderImageForQuality: quality]
                           options: SDWebImageCacheMemoryOnly
                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                             if (error) {
                                 weakImageView.image = [self noArtworkImageForQuality: quality];
                                 [weakImageView setNeedsLayout];
                             }
                         }];
    }
}

+ (UIImage*) placeholderImageForQuality: (EBTrackArtQuality) quality
{
    switch (quality) {
        case EBTrackArtQualityThumb:
            return [UIImage imageNamed: @"Downloading_Artwork_Thumb.png"];
        default:
            return [UIImage imageNamed: @"Downloading_Artwork.png"];
    }
}

+ (UIImage*) noArtworkImageForQuality: (EBTrackArtQuality) quality
{
    switch (quality) {
        case EBTrackArtQualityThumb:
            return [UIImage imageNamed: @"No_Artwork_Thumb.png"];
        default:
            return [UIImage imageNamed: @"No_Artwork.png"];
    }
}

+ (NSURL*) applicationSupportPath
{
    NSURL *appSupport = [[self libraryPath] URLByAppendingPathComponent: @"Application Support"];
    NSFileManager *fileManager = [NSFileManager new];
    [fileManager createDirectoryAtURL: appSupport withIntermediateDirectories: NO attributes: nil error: nil];
    return appSupport;
}

+ (NSURL*) cachePath
{
    NSURL *cachePath = [NSURL fileURLWithPath: [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]];
    NSFileManager *fileManager = [NSFileManager new];
    [fileManager createDirectoryAtURL: cachePath withIntermediateDirectories: YES attributes: nil error: nil];
    return cachePath;
}

+ (NSURL*) libraryPath
{
    return [NSURL fileURLWithPath: [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject]];
}

+ (NSURL*) documentsPath
{
    return [NSURL fileURLWithPath: [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]];
}

+ (NSURL*) applicationBinaryPath
{
    NSURL *path = [[NSBundle mainBundle] bundleURL];
    NSArray *pathArray = [path pathComponents];
    
    NSString *appName = [pathArray lastObject];
    NSString *binaryName = [[appName componentsSeparatedByString:@"."] objectAtIndex:0];
    return [path URLByAppendingPathComponent:binaryName];
}

@end
