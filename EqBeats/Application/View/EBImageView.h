//
//  EBImageView.h
//  EqBeats
//
//  Created by Tyrone Trevorrow on 2/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "UIViewDesiredHeight.h"
#import "UIViewDesiredWidth.h"

@interface EBImageView : UIImageView <UIViewDesiredHeight, UIViewDesiredWidth>
@property (nonatomic, strong) NSURL *currentImageURL;

- (void) loadImageFromURL: (NSURL*) url placeHolderImage: (UIImage*) placeholder completion: (void (^)(UIImage *image, NSError *error, SDImageCacheType cacheType)) completion;
- (void) loadImageFromURL: (NSURL*) url placeHolderImage: (UIImage*) placeholder progress: (SDWebImageDownloaderProgressBlock) progress completion: (void (^)(UIImage *image, NSError *error, SDImageCacheType cacheType)) completion;
- (void) loadImageFromURL: (NSURL*) url placeHolderImage: (UIImage*) placeholder imageManager: (SDWebImageManager*) manager progress: (SDWebImageDownloaderProgressBlock) progress completion: (void (^)(UIImage *image, NSError *error, SDImageCacheType cacheType)) completion;


@end
