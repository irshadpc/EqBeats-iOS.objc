//
//  EBModel.m
//  EqBeats
//
//  Created by Tyrone Trevorrow on 6/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import "EBModel.h"
#import "EBResourcesController.h"

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
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        EBLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

@end
