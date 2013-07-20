//
//  EBPlaylist.h
//  EqBeats
//
//  Created by Tyrone Trevorrow on 2/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "EBModelObject.h"

@class EBTrack, EBUser;

@interface EBPlaylist : EBModelObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic) int32_t sortIndex;
@property (nonatomic, retain) EBUser *author;
@property (nonatomic, retain) NSOrderedSet *tracks;
@end

@interface EBPlaylist (CoreDataGeneratedAccessors)

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
@end
