//
//  NSString+Color.m
//  EqBeats
//
//  Created by Tyrone Trevorrow on 11/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import "NSString+Color.h"
#import "UIColor+HexHTML.h"

@implementation NSString (Color)

- (UIColor*) color
{
    return [UIColor colorWithHTML: self];
}

@end
