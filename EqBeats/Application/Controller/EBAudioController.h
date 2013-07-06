//
//  EBAudioController.h
//  EqBeats
//
//  Created by Tyrone Trevorrow on 1/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

extern NSString* const EBAudioControllerPlaybackHeadMovedNotification;
extern NSString* const EBAudioControllerCurrentItemChangedNotification;

@class EBTrack;

@interface EBAudioController : NSObject
// Playback Queue is the list of EBTrack objects in the current list.
// Items do _not_ get purged from this list after they're played.
@property (nonatomic, copy) NSArray *playbackQueue;
@property (nonatomic, assign) NSInteger queueIndex;
@property (nonatomic, readonly) AVPlayerItem *currentItem;
@property (nonatomic, readonly) EBTrack *currentTrack;

- (NSNumber*) elapsedTime;
- (NSNumber*) duration;

- (void) togglePlayPause;
- (void) stop;
- (void) play;
- (void) skipForwards;
- (void) skipBackwards;
- (BOOL) playing;
- (BOOL) hasNextItem;
- (BOOL) hasPreviousItem;

@end
