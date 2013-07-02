//
//  EBUser.h
//  EqBeats
//
//  Created by Tyrone Trevorrow on 2/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "EBModelObject.h"

@class EBPlaylist, EBTrack;

@interface EBUser : EBModelObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * avatar;
@property (nonatomic, retain) NSOrderedSet *tracks;
@property (nonatomic, retain) NSOrderedSet *playlists;
@end

@interface EBUser (CoreDataGeneratedAccessors)

- (void)insertObject:(EBTrack *)value inTracksAtIndex:(NSUInteger)idx;
- (void)removeObjectFromTracksAtIndex:(NSUInteger)idx;
- (void)insertTracks:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeTracksAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInTracksAtIndex:(NSUInteger)idx withObject:(EBTrack *)value;
- (void)replaceTracksAtIndexes:(NSIndexSet *)indexes withTracks:(NSArray *)values;
- (void)addTracksObject:(EBTrack *)value;
- (void)removeTracksObject:(EBTrack *)value;
- (void)addTracks:(NSOrderedSet *)values;
- (void)removeTracks:(NSOrderedSet *)values;
- (void)insertObject:(EBPlaylist *)value inPlaylistsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPlaylistsAtIndex:(NSUInteger)idx;
- (void)insertPlaylists:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePlaylistsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPlaylistsAtIndex:(NSUInteger)idx withObject:(EBPlaylist *)value;
- (void)replacePlaylistsAtIndexes:(NSIndexSet *)indexes withPlaylists:(NSArray *)values;
- (void)addPlaylistsObject:(EBPlaylist *)value;
- (void)removePlaylistsObject:(EBPlaylist *)value;
- (void)addPlaylists:(NSOrderedSet *)values;
- (void)removePlaylists:(NSOrderedSet *)values;
@end
