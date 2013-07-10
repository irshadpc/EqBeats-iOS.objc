//
//  EBAPI.h
//  EqBeats
//
//  Created by Tyrone Trevorrow on 2/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EBAPI : NSObject

+ (void) getUserWithSearchQuery: (NSString*) query completion: (void (^)(NSArray *objects, NSError *error)) completion;
+ (void) getLatestTracksCompletion: (void (^)(NSArray *objects, NSError *error)) completion;
+ (void) getFeaturedTracksCompletion: (void (^)(NSArray *objects, NSError *error)) completion;
+ (void) getRandomTracksCompletion: (void (^)(NSArray *objects, NSError *error)) completion;

+ (void) getTracksWithSearchQuery: (NSString*) query completion: (void (^)(NSArray *objects, NSError *error)) completion;

+ (void) getObjectsFromURL: (NSURL*) url objectClass: (Class) objectClass completion: (void (^)(NSArray *objects, NSError *error)) completion;

@end
