//
//  EBAudioController.m
//  EqBeats
//
//  Created by Tyrone Trevorrow on 1/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import "EBAudioController.h"
#import "EBTrack.h"

@interface AVQueuePlayer (EBAudioController)
- (void) setItems: (NSArray*) items;
@end

@implementation AVQueuePlayer (EBAudioController)

- (void) setItems:(NSArray *)items
{
    [self removeAllItems];
    for (AVPlayerItem *item in items) {
        [self insertItem: item afterItem: nil];
    }
}

@end

NSString* const EBAudioControllerPlaybackHeadMovedNotification = @"EBAudioControllerPlaybackHeadMovedNotification";
NSString* const EBAudioControllerCurrentItemChangedNotification = @"EBAudioControllerCurrentItemChangedNotification";
NSString* const EBAudioControllerStatusChangedNotification = @"EBAudioControllerStatusChangedNotification";


@interface EBAudioController () {
    AVPlayerItem *_lastNotifiedItem;
}
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
    [self.currentPlayer removeAllItems];
    if (self.currentPlayer == nil) {
        self.currentPlayer = [[AVQueuePlayer alloc] initWithItems: playerItems];
    } else {
        [self.currentPlayer setItems: playerItems];
    }
}

- (void) setPlaybackQueue:(NSArray *)playbackQueue queueIndex:(NSInteger)index
{
    _playbackQueue = playbackQueue.copy;
    NSMutableArray *items = [NSMutableArray new];
    for (EBTrack *track in playbackQueue) {
        AVPlayerItem *item = [self playerItemForTrack: track];
        [item addObserver: self forKeyPath: @"status" options: NSKeyValueObservingOptionNew context: NULL];
        [item addObserver: self forKeyPath: @"playbackLikelyToKeepUp" options: NSKeyValueObservingOptionNew context: NULL];
        [items addObject: item];
    }
    for (AVPlayerItem *item in self.queueItems) {
        [item removeObserver: self forKeyPath: @"status"];
        [item removeObserver: self forKeyPath: @"playbackLikelyToKeepUp"];
    }
    self.queueItems = items;
    [self setQueueIndex: index];
}

- (void) setPlaybackQueue:(NSArray *)playbackQueue
{
    [self setPlaybackQueue: playbackQueue queueIndex: 0];
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
        [_currentPlayer addObserver: self forKeyPath: @"currentItem" options: NSKeyValueObservingOptionInitial| NSKeyValueObservingOptionNew context: NULL];
        [_currentPlayer addObserver: self forKeyPath: @"rate" options: NSKeyValueObservingOptionNew context: NULL];
        __weak id s = self;
        self.timeObserver = [_currentPlayer addPeriodicTimeObserverForInterval: CMTimeMakeWithSeconds(0.1, NSEC_PER_SEC) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            [[NSNotificationCenter defaultCenter] postNotificationName: EBAudioControllerPlaybackHeadMovedNotification object: s];
        }];
    }
}

- (EBTrack*) currentTrack
{
    NSInteger index = self.queueIndex;
    if (index == NSNotFound) {
        return nil;
    } else {
        return self.playbackQueue[self.queueIndex];
    }
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString: @"currentItem"]) {
        [self currentItemChanged];
    } else if ([keyPath isEqualToString: @"rate"]) {
        [self playbackStateChanged];
    } else if ([keyPath isEqualToString: @"status"]) {
        [self itemStatusChanged: object];
    } else if ([keyPath isEqualToString: @"playbackLikelyToKeepUp"]) {
        [self itemPlaybackLikelyToKeepUpChanged: object];
    }
}

- (void) currentItemChanged
{
    if (self.currentItem != _lastNotifiedItem) {
        [[NSNotificationCenter defaultCenter] postNotificationName: EBAudioControllerCurrentItemChangedNotification object: self];
        _lastNotifiedItem = self.currentItem;
    }
}

- (void) playbackStateChanged
{
    EBLog(@"Playback state changed: %@ newRate: %.2f", self.currentPlayer, self.currentPlayer.rate);
    [[NSNotificationCenter defaultCenter] postNotificationName: EBAudioControllerStatusChangedNotification object: self];
}

- (void) itemStatusChanged: (AVPlayerItem*) changedItem
{
    if (changedItem == self.currentItem && changedItem.status == AVPlayerStatusFailed) {
        [self skipForwards];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName: EBAudioControllerStatusChangedNotification object: self];
}

- (void) itemPlaybackLikelyToKeepUpChanged: (AVPlayerItem*) changedItem
{
    EBLog(@"Item: %@ likelyToKeepUp: %@", changedItem, (changedItem.playbackLikelyToKeepUp?@"YES":@"NO"));
    if (changedItem == self.currentItem && _autoplay && changedItem.playbackLikelyToKeepUp) {
        [self.currentPlayer play];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName: EBAudioControllerStatusChangedNotification object: self];
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
    if (self.currentPlayer == nil || self.playbackQueue.count < 2) {
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
