//
//  UIColor+HexHTML.h
//  EqBeats
//
//  Created by Tyrone Trevorrow on 11/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

@interface UIColor (HexHTML)

+ (UIColor*) colorWithRGB: (NSUInteger) rgb;

+ (UIColor*) colorWithRGBA: (NSUInteger) rgba;

// Also supports a bunch of HTML colour names.
+ (UIColor*) colorWithHTML: (NSString*) html;

@end
