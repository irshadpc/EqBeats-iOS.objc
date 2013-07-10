//
//  EBModelObject.m
//  EqBeats
//
//  Created by Tyrone Trevorrow on 2/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import "EBModelObject.h"

@implementation EBKeyTransformer

+ (Class) transformedValueClass
{
    return [NSString class];
}

- (NSString*) transformedValue:(NSString*)value
{
    static NSDictionary *map = nil;
    if (map == nil) {
        map = @{ @"id": @"uid",
                 @"html_description": @"htmlDescription" };
    }
    NSString *mapped = map[value];
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
    
    
    
    return nil;
}

+ (instancetype) objectWithUID:(NSUInteger)uid inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName: NSStringFromClass(self)];
    fetchRequest.predicate = [NSPredicate predicateWithFormat: @"uid == %i", uid];
    NSArray *results = [context executeFetchRequest: fetchRequest error: nil];
    if (results.count > 0) {
        return results[0];
    }
    return nil;
}

@end
