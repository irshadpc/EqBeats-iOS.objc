//
//  EBResourcesController.m
//  EqBeats
//
//  Created by Tyrone Trevorrow on 2/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import "EBResourcesController.h"
#import "UIImageView+WebCache.h"
#import "EBImageView.h"

NSUInteger EBDeviceSystemMajorVersion() {
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    return _deviceSystemMajorVersion;
}

@interface SDWebImageManager ()
@property (strong, nonatomic, readwrite) SDImageCache *imageCache;
@end

@implementation EBTrackArtworkDownloadManager

+ (instancetype) sharedManager
{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{instance = self.new;});
    return instance;
}

- (id) init
{
    self = [super init];
    if (self) {
        self.imageCache = [[SDImageCache alloc] initWithNamespace: @"artwork"];
    }
    return self;
}

@end

@implementation EBResourcesController

+ (void) setImageForImageView: (EBImageView*) imageView
                        track: (EBTrack*) track
                      quality: (EBTrackArtQuality) quality
{
    [self setImageForImageView: imageView track: track quality: quality progress: nil];
}

+ (void) setImageForImageView: (EBImageView*) imageView
                        track: (EBTrack*) track
                      quality: (EBTrackArtQuality) quality
                     progress: (SDWebImageDownloaderProgressBlock) progress
{
    if ([track artURLAtQuality: quality] == nil) {
        [imageView setImage: [self noArtworkImageForQuality: quality]];
    } else {
        __weak EBImageView *weakImageView = imageView;
        SDWebImageManager *manager = [EBTrackArtworkDownloadManager sharedManager];
        if (quality != EBTrackArtQualityThumb) {
            manager = [SDWebImageManager sharedManager];
        }
        NSURL *url = [track artURLAtQuality: quality];
        if (![imageView.currentImageURL isEqual: url]) {
            [imageView loadImageFromURL: url
                       placeHolderImage: [self placeholderImageForQuality: quality]
                           imageManager: manager
                               progress: progress
                             completion:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                 if (image == nil || error != nil) {
                                     weakImageView.image = [self noArtworkImageForQuality: quality];
                                 }
                             }];
        }
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
