//
//  EBAudioController.m
//  EqBeats
//
//  Created by Tyrone Trevorrow on 1/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import "EBAudioController.h"
#import "EBTrack.h"

NSString* const EBAudioControllerPlaybackHeadMovedNotification = @"EBAudioControllerPlaybackHeadMovedNotification";
NSString* const EBAudioControllerCurrentItemChangedNotification = @"EBAudioControllerCurrentItemChangedNotification";


@interface EBAudioController ()
@property (nonatomic, strong) AVQueuePlayer *currentPlayer;
@property (nonatomic, copy) NSArray *queueItems;
@property (nonatomic, strong) id timeObserver;
@end

@implementation EBAudioController {
    BOOL _autoplay;
}

- (AVPlayerItem*) currentItem
{
    return self.currentPlayer.currentItem;
}

- (NSInteger) queueIndex
{
    return [self.queueItems indexOfObject: self.currentItem];
}

- (void) setQueueIndex:(NSInteger)queueIndex
{
    NSArray *playerItems = [self.queueItems subarrayWithRange: NSMakeRange(queueIndex, self.queueItems.count - queueIndex)];
    self.currentPlayer = [[AVQueuePlayer alloc] initWithItems: playerItems];
}

- (void) setPlaybackQueue:(NSArray *)playbackQueue
{
    _playbackQueue = playbackQueue.copy;
    NSMutableArray *items = [NSMutableArray new];
    for (EBTrack *track in playbackQueue) {
        AVPlayerItem *item = [self playerItemForTrack: track];
        [item addObserver: self forKeyPath: @"status" options: NSKeyValueObservingOptionNew context: NULL];
        [items addObject: item];
    }
    for (AVPlayerItem *item in self.queueItems) {
        [item removeObserver: self forKeyPath: @"status"];
    }
    self.queueItems = items;
    [self setQueueIndex: 0];
}

- (void) setCurrentPlayer:(AVQueuePlayer *)currentPlayer
{
    if (_currentPlayer != nil) {
        [_currentPlayer removeObserver: self forKeyPath: @"currentItem"];
        [_currentPlayer removeObserver: self forKeyPath: @"rate"];
        if (self.timeObserver) {
            [_currentPlayer removeTimeObserver: self.timeObserver];
        }
    }
    
    _currentPlayer = currentPlayer;
    
    if (_currentPlayer != nil) {
        [_currentPlayer addObserver: self forKeyPath: @"currentItem" options: NSKeyValueObservingOptionNew context: NULL];
        [_currentPlayer addObserver: self forKeyPath: @"rate" options: NSKeyValueObservingOptionNew context: NULL];
        __weak id s = self;
        self.timeObserver = [_currentPlayer addPeriodicTimeObserverForInterval: CMTimeMakeWithSeconds(0.1, NSEC_PER_SEC) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            [[NSNotificationCenter defaultCenter] postNotificationName: EBAudioControllerPlaybackHeadMovedNotification object: s];
        }];
    }
}

- (EBTrack*) currentTrack
{
    return self.playbackQueue[self.queueIndex];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString: @"currentItem"]) {
        [self currentItemChanged];
    } else if ([keyPath isEqualToString: @"rate"]) {
        [self playbackStateChanged];
    } else if ([keyPath isEqualToString: @"status"]) {
        [self itemStatusChanged: object];
    }
}

- (void) currentItemChanged
{
    
}

- (void) playbackStateChanged
{
    
}

- (void) itemStatusChanged: (AVPlayerItem*) changedItem
{
    
}

#pragma mark - Public Playback Controls

- (void) togglePlayPause
{
    if (self.playing || _autoplay) {
        _autoplay = NO;
        [self.currentPlayer pause];
    } else {
        _autoplay = YES;
        [self.currentPlayer play];
    }
}

- (void) stop
{
    [self.currentPlayer setRate: 0];
    [self.currentItem seekToTime: kCMTimeZero];
}

- (void) play
{
    _autoplay = YES;
    [self.currentPlayer play];
}

- (void) skipForwards
{
    [self.currentPlayer advanceToNextItem];
    [self.currentPlayer.currentItem seekToTime: kCMTimeZero];
}

- (void) skipBackwards
{
    if ([self shouldSkipToTrackStart]) {
        [self.currentItem seekToTime: kCMTimeZero];
    } else {
        [self setQueueIndex: self.queueIndex - 1];
    }
}

- (BOOL) playing
{
    return self.currentPlayer.rate > 0;
}

#pragma mark - Helpers

- (NSNumber*) elapsedTime
{
    if (self.currentItem == nil) {
        return nil;
    } else {
        return @(CMTimeGetSeconds(self.currentItem.currentTime));
    }
}

- (NSNumber*) duration
{
    if (self.currentItem == nil) {
        return nil;
    } else {
        return @(CMTimeGetSeconds(self.currentItem.duration));
    }
}

- (BOOL) shouldSkipToTrackStart
{
    if (![self hasPreviousItem] || self.elapsedTime.doubleValue > 3) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL) hasPreviousItem
{
    if (self.currentPlayer == nil || self.currentPlayer.items.count < 2) {
        return NO;
    } else {
        return [self queueIndex] > 0;
    }
}

- (BOOL) hasNextItem
{
    if (self.currentPlayer.items.count < 2) {
        return NO;
    } else {
        return YES;
    }
}

- (AVPlayerItem*) playerItemForTrack: (EBTrack*) track
{
    return [[AVPlayerItem alloc] initWithURL: track.assetURL];
}

@end
