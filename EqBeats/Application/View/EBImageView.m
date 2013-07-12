//
//  EBImageView.m
//  EqBeats
//
//  Created by Tyrone Trevorrow on 2/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import "EBImageView.h"
#import "SDWebImageManager.h"

@interface EBImageView ()
@property (nonatomic, strong) NSOperation *loadImageOperation;
@end

@implementation EBImageView

- (void) cancelCurrentImageLoad
{
    [super cancelCurrentImageLoad];
    if (self.loadImageOperation != nil) {
        [self.loadImageOperation cancel];
        self.loadImageOperation = nil;
    }
}

- (void) loadImageFromURL: (NSURL*) url placeHolderImage: (UIImage*) placeholder completion: (void (^)(UIImage *image, NSError *error, SDImageCacheType cacheType)) completion
{
    [self cancelCurrentImageLoad];
    if (placeholder) {
        self.image = placeholder;
    }
    
    if (url != nil) {
        self.loadImageOperation = [[SDWebImageManager sharedManager] downloadWithURL: url options: 0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
            if (image != nil) {
                self.image = image;
                [self setNeedsLayout];
            }
            if (completion != NULL) {
                completion(image, error, cacheType);
            }
        }];
    }
}

- (NSNumber*) desiredHeight
{
    return @(self.frame.size.height);
}

- (NSNumber*) desiredWidth
{
    return @(self.frame.size.width);
}

@end
