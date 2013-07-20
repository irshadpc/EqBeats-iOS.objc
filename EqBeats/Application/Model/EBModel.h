//
//  EBModel.h
//  EqBeats
//
//  Created by Tyrone Trevorrow on 6/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "EBAudioController.h"

@interface EBModel : NSObject
@property (nonatomic, strong) EBAudioController *audioController;
@property (nonatomic, strong, readonly) NSManagedObjectContext *mainThreadObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (EBModel*) sharedModel;

// Fetches.  These fetch requests do no caching at all.  Every time you call them, it'll
// hit the database.
+ (NSArray*) allPlaylists;

@end
