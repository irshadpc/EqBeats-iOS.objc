//
//  EBResourcesController.m
//  EqBeats
//
//  Created by Tyrone Trevorrow on 2/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import "EBResourcesController.h"
#import "UIImageView+WebCache.h"

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

@end
