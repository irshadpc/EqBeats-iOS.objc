//
//  EBArrayUtility.m
//  EqBeats
//
//  Created by Tyrone Trevorrow on 24/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import "EBArrayUtility.h"

@implementation EBArrayUtility

+ (void) shuffleArray:(NSMutableArray *)array
{
    [self shuffleElementsInArray: array afterIndex: 0];
}

+ (void) shuffleElementsInArray:(NSMutableArray *)array afterIndex:(NSUInteger)index
{
    NSInteger count = array.count;
    for (int i = index; i < count; i++) {
        NSInteger index = arc4random_uniform(count-i) + i;
        [array exchangeObjectAtIndex: i withObjectAtIndex: index];
    }
}

@end
