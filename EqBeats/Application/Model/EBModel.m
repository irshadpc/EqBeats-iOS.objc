//
//  EBModel.m
//  EqBeats
//
//  Created by Tyrone Trevorrow on 6/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import "EBModel.h"
#import "EBResourcesController.h"
#import "NSManagedObjectModel+KCOrderedAccessorFix.h"

@implementation EBModel
@synthesize mainThreadObjectContext = _mainThreadObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (EBModel*) sharedModel
{
    __strong static EBModel *sharedModel = nil;
    if (sharedModel == nil) {
        sharedModel = [EBModel new];
    }
    return sharedModel;
}

- (id) init
{
    self = [super init];
    if (self) {
        self.audioController = [EBAudioController new];
        [self mainThreadObjectContext];
        [[self managedObjectModel] kc_generateOrderedSetAccessors];
    }
    return self;
}

- (NSManagedObjectContext *) mainThreadObjectContext
{
    if (_mainThreadObjectContext != nil) {
        return _mainThreadObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _mainThreadObjectContext = [[NSManagedObjectContext alloc] init];
        [_mainThreadObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _mainThreadObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"EqBeats" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[EBResourcesController documentsPath] URLByAppendingPathComponent:@"EqBeats.db"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSDictionary *options = @{ NSSQLitePragmasOption: @{ @"synchronous": @"OFF",
                                                         @"journal_mode": @"TRUNCATE"}};
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:storeURL
                                                         options: options
                                                           error:&error]) {
        // TODO: Migrations
        EBLog(@"Deleting incompatible Core Data store: %@", storeURL.absoluteString);
        NSFileManager *fm = [NSFileManager new];
        [fm removeItemAtURL: storeURL error: &error];
        error = nil;
        if (error) {
            EBLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                       configuration:nil
                                                                 URL:storeURL
                                                             options:options
                                                               error:&error]) {
            EBLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Fetches

+ (NSArray*) allPlaylists
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName: @"EBPlaylist"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey: @"sortIndex" ascending: YES]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat: @"lovedPlaylist == NO"];
    return [[self.sharedModel mainThreadObjectContext] executeFetchRequest: fetchRequest error: nil];
}

+ (EBPlaylist*) lovedPlaylist
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName: @"EBPlaylist"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat: @"lovedPlaylist == YES"];
    NSArray *results = [[self.sharedModel mainThreadObjectContext] executeFetchRequest: fetchRequest error: nil];
    if (results == nil || results.count == 0) {
        EBPlaylist *playlist = [NSEntityDescription insertNewObjectForEntityForName: @"EBPlaylist" inManagedObjectContext: self.sharedModel.mainThreadObjectContext];
        playlist.lovedPlaylist = YES;
        [self.sharedModel.mainThreadObjectContext save: nil];
        results = @[playlist];
    }
    return results[0];
}

@end
