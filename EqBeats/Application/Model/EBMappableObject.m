//
//  EBMappableObject.m
//  EqBeats
//
//  Created by Tyrone Trevorrow on 11/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import "EBMappableObject.h"
#import "EBModelObject.h"

@implementation EBMappableObject

+ (NSValueTransformer*) mappingKeyTransformer
{
    return nil;
}

+ (instancetype) objectFromMappableData:(NSDictionary *)mappableData inContext:(NSManagedObjectContext *)context
{
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName: NSStringFromClass(self) inManagedObjectContext: context];
    EBMappableObject *entity = [[self alloc] initWithEntity: entityDesc insertIntoManagedObjectContext: context];
    [self updateEntity: entity withMappableData: mappableData inContext: context];
    return entity;
}

+ (void) updateEntity: (EBMappableObject*) entity withMappableData: (NSDictionary*) mappableData inContext: (NSManagedObjectContext*) context;
{
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName: NSStringFromClass(self) inManagedObjectContext: context];
    NSDictionary *relations = [entityDesc relationshipsByName];
    
    for (NSString *key in mappableData) {
        NSString *propKey = [[self mappingKeyTransformer] transformedValue: key];
        if (propKey == nil) {
            propKey = key;
        }
        id value = mappableData[key];
        if ([value isKindOfClass: [NSDictionary class]] && relations[propKey] != nil) {
            // This is a relationship... use sub-mapping.
            NSRelationshipDescription *prop = relations[propKey];
            Class destinationClass = NSClassFromString([[prop destinationEntity] managedObjectClassName]);
            value = [destinationClass objectFromMappableData: value inContext: context];
        }
        [entity setValue: value forKey: propKey];
    }
}

@end
