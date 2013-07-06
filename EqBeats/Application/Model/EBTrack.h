//
//  EBTrack.h
//  EqBeats
//
//  Created by Tyrone Trevorrow on 6/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "EBModelObject.h"

@class EBDownload, EBUser;

typedef NS_ENUM(NSInteger, EBTrackArtQuality) {
    EBTrackArtQualityFull,
    EBTrackArtQualityMedium,
    EBTrackArtQualityThumb
};

@interface EBTrack : EBModelObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) EBUser *artist;
@property (nonatomic, retain) EBDownload *stream;
@property (nonatomic, retain) EBDownload *download;

- (BOOL) isCached;
- (NSURL*) assetURL;
- (NSURL*) cacheURL;
- (NSURL*) artURL;
- (NSURL*) artURLAtQuality: (EBTrackArtQuality) quality;

@end
