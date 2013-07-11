//
//  EBMappableObject.h
//  EqBeats
//
//  Created by Tyrone Trevorrow on 11/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface EBMappableObject : NSManagedObject

+ (NSValueTransformer*) mappingKeyTransformer;
+ (instancetype) objectFromMappableData: (NSDictionary*) mappableData inContext: (NSManagedObjectContext*) context;

+ (void) updateEntity: (EBMappableObject*) entity withMappableData: (NSDictionary*) mappableData inContext: (NSManagedObjectContext*) context;


@end
