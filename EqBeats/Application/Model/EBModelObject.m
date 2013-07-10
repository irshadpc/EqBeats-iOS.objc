//
//  EBModelObject.m
//  EqBeats
//
//  Created by Tyrone Trevorrow on 2/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import "EBModelObject.h"

@implementation EBKeyTransformer

static NSDictionary *map = nil;
static NSDictionary *inverseMap = nil;

+ (Class) transformedValueClass
{
    return [NSString class];
}

+ (BOOL) allowsReverseTransformation
{
    return YES;
}

NS_INLINE void setupMap()
{
    map = @{ @"id": @"uid",
             @"html_description": @"htmlDescription" };
    NSMutableDictionary *d = [[NSMutableDictionary alloc] initWithCapacity: map.count];
    for (NSString *key in map) {
        NSString *v = map[key];
        d[v] = key;
    }
    inverseMap = d.copy;
}

- (NSString*) transformedValue:(NSString*)value
{
    if (map == nil) {
        setupMap();
    }
    NSString *mapped = map[value];
    if (mapped) {
        return mapped;
    } else {
        return value;
    }
}

- (NSString*) reverseTransformedValue:(NSString*)value
{
    if (map == nil) {
        setupMap();
    }
    NSString *mapped = inverseMap[value];
    if (mapped) {
        return mapped;
    } else {
        return value;
    }
}

@end

@implementation EBModelObject

@dynamic uid;
@dynamic detail;
@dynamic htmlDescription;
@dynamic link;
@dynamic plainDetail;

+ (NSValueTransformer*) mappingKeyTransformer
{
    static EBKeyTransformer* sharedTransformer = nil;
    if (sharedTransformer == nil) {
        sharedTransformer = [EBKeyTransformer new];
    }
    return sharedTransformer;
}

+ (instancetype) objectFromMappableData:(NSDictionary *)mappableData inContext:(NSManagedObjectContext *)context
{
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName: NSStringFromClass(self) inManagedObjectContext: context];
    NSDictionary *relations = [entityDesc relationshipsByName];
    NSString *idKey = [[self mappingKeyTransformer] reverseTransformedValue: @"uid"];
    NSNumber *idValue = mappableData[idKey];
    if (idValue == nil) {
        // Invalid mappable data.
        EBLog(@"Failed to map data: no identity key.  data: %@", mappableData);
        return nil;
    }
    
    EBModelObject *entity = [self objectWithUID: [idValue integerValue] inContext: context createIfNotFound: YES];
    for (NSString *key in mappableData) {
        NSString *propKey = [[self mappingKeyTransformer] transformedValue: key];
        id value = mappableData[key];
        if ([value isKindOfClass: [NSDictionary class]] && relations[propKey] != nil) {
            // This is a relationship... use sub-mapping.
            NSRelationshipDescription *prop = relations[propKey];
            Class destinationClass = NSClassFromString([[prop destinationEntity] managedObjectClassName]);
            value = [destinationClass objectFromMappableData: value inContext: context];
        }
        [entity setValue: value forKey: propKey];
    }
    return entity;
}

+ (instancetype) objectWithUID:(NSUInteger)uid inContext:(NSManagedObjectContext *)context
{
    return [self objectWithUID: uid inContext: context createIfNotFound: NO];
}

+ (instancetype) objectWithUID: (NSUInteger) uid inContext: (NSManagedObjectContext*) context createIfNotFound: (BOOL) create
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName: NSStringFromClass(self)];
    fetchRequest.predicate = [NSPredicate predicateWithFormat: @"uid == %i", uid];
    NSArray *results = [context executeFetchRequest: fetchRequest error: nil];
    if (results.count > 0) {
        return results[0];
    }
    
    // Create a new object, but don't write it yet since this might be happening in a loop.
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName: NSStringFromClass(self) inManagedObjectContext: context];
    EBModelObject *object = [[self alloc] initWithEntity: entityDesc insertIntoManagedObjectContext: context];
    object.uid = uid;
    return object;
}

@end
