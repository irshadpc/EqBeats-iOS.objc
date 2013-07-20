//
//  EBTrack.m
//  EqBeats
//
//  Created by Tyrone Trevorrow on 6/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import "EBTrack.h"
#import "EBDownload.h"
#import "EBUser.h"


@implementation EBTrack {
    NSNumber *_cached;
}

@dynamic title;
@dynamic duration;
@dynamic artist;
@dynamic stream;
@dynamic download;

- (NSURL*) assetURL
{
    if ([self isCached]) {
        return self.cacheURL;
    } else {
        return [NSURL URLWithString: self.stream.aac];
    }
}

- (NSURL*) cacheURL
{
    NSURL *url = [[NSFileManager defaultManager] URLForDirectory: NSCachesDirectory
                                                        inDomain: NSUserDomainMask
                                               appropriateForURL: nil
                                                          create: YES
                                                           error: NULL];
    return [NSURL URLWithString: [NSString stringWithFormat: @"/track_%i", self.uid] relativeToURL: url];
}

- (BOOL) isCached
{
    if (_cached == nil) {
        NSFileManager *fm = [NSFileManager new];
        _cached = @([fm fileExistsAtPath: self.cacheURL.absoluteString]);
    }
    return _cached.boolValue;
}

- (NSURL*) artURL
{
    return [self artURLAtQuality: EBTrackArtQualityFull];
}

- (NSURL*) artURLAtQuality:(EBTrackArtQuality)quality
{
    switch (quality) {
        case EBTrackArtQualityFull:
            return [NSURL URLWithString: self.download.art];
        case EBTrackArtQualityMedium:
            return [NSURL URLWithString: [NSString stringWithFormat: @"%@/medium",  self.download.art]];
        case EBTrackArtQualityThumb:
            return [NSURL URLWithString: [NSString stringWithFormat: @"%@/thumb",  self.download.art]];
        default:
            return [NSURL URLWithString: self.download.art];
    }
}

@end
