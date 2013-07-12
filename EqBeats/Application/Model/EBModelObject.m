//
//  EBModelObject.m
//  EqBeats
//
//  Created by Tyrone Trevorrow on 2/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import "EBModelObject.h"

@implementation EBModelObjectKeyTransformer

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
@synthesize plainDetail = _plainDetail;

+ (NSValueTransformer*) mappingKeyTransformer
{
    static EBModelObjectKeyTransformer* sharedTransformer = nil;
    if (sharedTransformer == nil) {
        sharedTransformer = [EBModelObjectKeyTransformer new];
    }
    return sharedTransformer;
}

+ (instancetype) objectFromMappableData:(NSDictionary *)mappableData inContext:(NSManagedObjectContext *)context
{
    NSString *idKey = [[self mappingKeyTransformer] reverseTransformedValue: @"uid"];
    NSNumber *idValue = mappableData[idKey];
    if (idValue == nil) {
        // Invalid mappable data.
        EBLog(@"Failed to map data: no identity key.  data: %@", mappableData);
        return nil;
    }
    
    EBModelObject *entity = [(id)self objectWithUID: [idValue integerValue] inContext: context createIfNotFound: YES];
    [self updateEntity: entity withMappableData: mappableData inContext: context];
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

- (void) didChangeValueForKey:(NSString *)key
{
    if ([key isEqualToString: @"detail"]) {
        NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern: @"\\[([^\\]=]*)[^\\]]*\\](.*)\\[\\/\\1\\]" options:NSRegularExpressionCaseInsensitive error: nil];
        self.plainDetail = [expr stringByReplacingMatchesInString: self.detail options: 0 range: NSMakeRange(0, self.detail.length) withTemplate: @"$2"];
    }
    [super didChangeValueForKey: key];
}

@end
