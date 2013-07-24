//
//  EBArrayUtility.h
//  EqBeats
//
//  Created by Tyrone Trevorrow on 24/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EBArrayUtility : NSObject

+ (void) shuffleArray: (NSMutableArray*) array;
+ (void) shuffleElementsInArray: (NSMutableArray*) array afterIndex: (NSUInteger) index;

@end

