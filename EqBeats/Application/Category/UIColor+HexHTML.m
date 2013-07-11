//
//  UIColor+HexHTML.m
//  EqBeats
//
//  Created by Tyrone Trevorrow on 11/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import "UIColor+HexHTML.h"

NS_INLINE UIColor* UIColorFromHexRGBA(NSUInteger hex)
{
    return [UIColor colorWithRed:((hex>>24)&0xFF)/255.0
                           green:((hex>>16)&0xFF)/255.0
                            blue:((hex>>8)&0xFF)/255.0
                           alpha:(hex&0xFF)/255.0];
}

NS_INLINE UIColor* UIColorFromHexRGB(NSUInteger hex)
{
    return [UIColor colorWithRed:((hex>>16)&0xFF)/255.0
                           green:((hex>>8)&0xFF)/255.0
                            blue:(hex&0xFF)/255.0
                           alpha:1];
}

@implementation UIColor (HexHTML)

__strong static NSDictionary *colorMap = nil;

__attribute__((constructor))
static void initializeHTMLColorMap()
{
    colorMap = @{
                 @"aliceblue":              UIColorFromHexRGB(0xF0F8FF),
                 @"antiquewhite":           UIColorFromHexRGB(0xFAEBD7),
                 @"aqua":                   UIColorFromHexRGB(0x00FFFF),
                 @"aquamarine":             UIColorFromHexRGB(0x7FFFD4),
                 @"azure":                  UIColorFromHexRGB(0xF0FFFF),
                 @"beige":                  UIColorFromHexRGB(0xF5F5DC),
                 @"bisque":                 UIColorFromHexRGB(0xFFE4C4),
                 @"black":                  UIColorFromHexRGB(0x000000),
                 @"blanchedalmond":         UIColorFromHexRGB(0xFFEBCD),
                 @"blue":                   UIColorFromHexRGB(0x0000FF),
                 @"blueviolet":             UIColorFromHexRGB(0x8A2BE2),
                 @"brown":                  UIColorFromHexRGB(0xA52A2A),
                 @"burlywood":              UIColorFromHexRGB(0xDEB887),
                 @"cadetblue":              UIColorFromHexRGB(0x5F9EA0),
                 @"chartreuse":             UIColorFromHexRGB(0x7FFF00),
                 @"chocolate":              UIColorFromHexRGB(0xD2691E),
                 @"coral":                  UIColorFromHexRGB(0xFF7F50),
                 @"cornflowerblue":         UIColorFromHexRGB(0x6495ED),
                 @"cornsilk":               UIColorFromHexRGB(0xFFF8DC),
                 @"crimson":                UIColorFromHexRGB(0xDC143C),
                 @"cyan":                   UIColorFromHexRGB(0x00FFFF),
                 @"darkblue":               UIColorFromHexRGB(0x00008B),
                 @"darkcyan":               UIColorFromHexRGB(0x008B8B),
                 @"darkgoldenrod":          UIColorFromHexRGB(0xB8860B),
                 @"darkgray":               UIColorFromHexRGB(0xA9A9A9),
                 @"darkgrey":               UIColorFromHexRGB(0xA9A9A9),
                 @"darkgreen":              UIColorFromHexRGB(0x006400),
                 @"darkkhaki":              UIColorFromHexRGB(0xBDB76B),
                 @"darkmagenta":            UIColorFromHexRGB(0x8B008B),
                 @"darkolivegreen":         UIColorFromHexRGB(0x556B2F),
                 @"darkorange":             UIColorFromHexRGB(0xFF8C00),
                 @"darkorchid":             UIColorFromHexRGB(0x9932CC),
                 @"darkred":                UIColorFromHexRGB(0x8B0000),
                 @"darksalmon":             UIColorFromHexRGB(0xE9967A),
                 @"darkseagreen":           UIColorFromHexRGB(0x8FBC8F),
                 @"darkslateblue":          UIColorFromHexRGB(0x483D8B),
                 @"darkslategray":          UIColorFromHexRGB(0x2F4F4F),
                 @"darkslategrey":          UIColorFromHexRGB(0x2F4F4F),
                 @"darkturquoise":          UIColorFromHexRGB(0x00CED1),
                 @"darkviolet":             UIColorFromHexRGB(0x9400D3),
                 @"deeppink":               UIColorFromHexRGB(0xFF1493),
                 @"deepskyblue":            UIColorFromHexRGB(0x00BFFF),
                 @"dimgray":                UIColorFromHexRGB(0x696969),
                 @"dimgrey":                UIColorFromHexRGB(0x696969),
                 @"dodgerblue":             UIColorFromHexRGB(0x1E90FF),
                 @"firebrick":              UIColorFromHexRGB(0xB22222),
                 @"floralwhite":            UIColorFromHexRGB(0xFFFAF0),
                 @"forestgreen":            UIColorFromHexRGB(0x228B22),
                 @"fuchsia":                UIColorFromHexRGB(0xFF00FF),
                 @"gainsboro":              UIColorFromHexRGB(0xDCDCDC),
                 @"ghostwhite":             UIColorFromHexRGB(0xF8F8FF),
                 @"gold":                   UIColorFromHexRGB(0xFFD700),
                 @"goldenrod":              UIColorFromHexRGB(0xDAA520),
                 @"gray":                   UIColorFromHexRGB(0x808080),
                 @"grey":                   UIColorFromHexRGB(0x808080),
                 @"green":                  UIColorFromHexRGB(0x008000),
                 @"greenyellow":            UIColorFromHexRGB(0xADFF2F),
                 @"honeydew":               UIColorFromHexRGB(0xF0FFF0),
                 @"hotpink":                UIColorFromHexRGB(0xFF69B4),
                 @"indianred":              UIColorFromHexRGB(0xCD5C5C),
                 @"indigo":                 UIColorFromHexRGB(0x4B0082),
                 @"ivory":                  UIColorFromHexRGB(0xFFFFF0),
                 @"khaki":                  UIColorFromHexRGB(0xF0E68C),
                 @"lavender":               UIColorFromHexRGB(0xE6E6FA),
                 @"lavenderblush":          UIColorFromHexRGB(0xFFF0F5),
                 @"lawngreen":              UIColorFromHexRGB(0x7CFC00),
                 @"lemonchiffon":           UIColorFromHexRGB(0xFFFACD),
                 @"lightblue":              UIColorFromHexRGB(0xADD8E6),
                 @"lightcoral":             UIColorFromHexRGB(0xF08080),
                 @"lightcyan":              UIColorFromHexRGB(0xE0FFFF),
                 @"lightgoldenrodyellow":   UIColorFromHexRGB(0xFAFAD2),
                 @"lightgray":              UIColorFromHexRGB(0xD3D3D3),
                 @"lightgrey":              UIColorFromHexRGB(0xD3D3D3),
                 @"lightgreen":             UIColorFromHexRGB(0x90EE90),
                 @"lightpink":              UIColorFromHexRGB(0xFFB6C1),
                 @"lightsalmon":            UIColorFromHexRGB(0xFFA07A),
                 @"lightseagreen":          UIColorFromHexRGB(0x20B2AA),
                 @"lightskyblue":           UIColorFromHexRGB(0x87CEFA),
                 @"lightslategray":         UIColorFromHexRGB(0x778899),
                 @"lightslategrey":         UIColorFromHexRGB(0x778899),
                 @"lightsteelblue":         UIColorFromHexRGB(0xB0C4DE),
                 @"lightyellow":            UIColorFromHexRGB(0xFFFFE0),
                 @"lime":                   UIColorFromHexRGB(0x00FF00),
                 @"limegreen":              UIColorFromHexRGB(0x32CD32),
                 @"linen":                  UIColorFromHexRGB(0xFAF0E6),
                 @"magenta":                UIColorFromHexRGB(0xFF00FF),
                 @"maroon":                 UIColorFromHexRGB(0x800000),
                 @"mediumaquamarine":       UIColorFromHexRGB(0x66CDAA),
                 @"mediumblue":             UIColorFromHexRGB(0x0000CD),
                 @"mediumorchid":           UIColorFromHexRGB(0xBA55D3),
                 @"mediumpurple":           UIColorFromHexRGB(0x9370D8),
                 @"mediumseagreen":         UIColorFromHexRGB(0x3CB371),
                 @"mediumslateblue":        UIColorFromHexRGB(0x7B68EE),
                 @"mediumspringgreen":      UIColorFromHexRGB(0x00FA9A),
                 @"mediumturquoise":        UIColorFromHexRGB(0x48D1CC),
                 @"mediumvioletred":        UIColorFromHexRGB(0xC71585),
                 @"midnightblue":           UIColorFromHexRGB(0x191970),
                 @"mintcream":              UIColorFromHexRGB(0xF5FFFA),
                 @"mistyrose":              UIColorFromHexRGB(0xFFE4E1),
                 @"moccasin":               UIColorFromHexRGB(0xFFE4B5),
                 @"navajowhite":            UIColorFromHexRGB(0xFFDEAD),
                 @"navy":                   UIColorFromHexRGB(0x000080),
                 @"oldlace":                UIColorFromHexRGB(0xFDF5E6),
                 @"olive":                  UIColorFromHexRGB(0x808000),
                 @"olivedrab":              UIColorFromHexRGB(0x6B8E23),
                 @"orange":                 UIColorFromHexRGB(0xFFA500),
                 @"orangered":              UIColorFromHexRGB(0xFF4500),
                 @"orchid":                 UIColorFromHexRGB(0xDA70D6),
                 @"palegoldenrod":          UIColorFromHexRGB(0xEEE8AA),
                 @"palegreen":              UIColorFromHexRGB(0x98FB98),
                 @"paleturquoise":          UIColorFromHexRGB(0xAFEEEE),
                 @"palevioletred":          UIColorFromHexRGB(0xD87093),
                 @"papayawhip":             UIColorFromHexRGB(0xFFEFD5),
                 @"peachpuff":              UIColorFromHexRGB(0xFFDAB9),
                 @"peru":                   UIColorFromHexRGB(0xCD853F),
                 @"pink":                   UIColorFromHexRGB(0xFFC0CB),
                 @"plum":                   UIColorFromHexRGB(0xDDA0DD),
                 @"powderblue":             UIColorFromHexRGB(0xB0E0E6),
                 @"purple":                 UIColorFromHexRGB(0x800080),
                 @"red":                    UIColorFromHexRGB(0xFF0000),
                 @"rosybrown":              UIColorFromHexRGB(0xBC8F8F),
                 @"royalblue":              UIColorFromHexRGB(0x4169E1),
                 @"saddlebrown":            UIColorFromHexRGB(0x8B4513),
                 @"salmon":                 UIColorFromHexRGB(0xFA8072),
                 @"sandybrown":             UIColorFromHexRGB(0xF4A460),
                 @"seagreen":               UIColorFromHexRGB(0x2E8B57),
                 @"seashell":               UIColorFromHexRGB(0xFFF5EE),
                 @"sienna":                 UIColorFromHexRGB(0xA0522D),
                 @"silver":                 UIColorFromHexRGB(0xC0C0C0),
                 @"skyblue":                UIColorFromHexRGB(0x87CEEB),
                 @"slateblue":              UIColorFromHexRGB(0x6A5ACD),
                 @"slategray":              UIColorFromHexRGB(0x708090),
                 @"slategrey":              UIColorFromHexRGB(0x708090),
                 @"snow":                   UIColorFromHexRGB(0xFFFAFA),
                 @"springgreen":            UIColorFromHexRGB(0x00FF7F),
                 @"steelblue":              UIColorFromHexRGB(0x4682B4),
                 @"tan":                    UIColorFromHexRGB(0xD2B48C),
                 @"teal":                   UIColorFromHexRGB(0x008080),
                 @"thistle":                UIColorFromHexRGB(0xD8BFD8),
                 @"tomato":                 UIColorFromHexRGB(0xFF6347),
                 @"turquoise":              UIColorFromHexRGB(0x40E0D0),
                 @"violet":                 UIColorFromHexRGB(0xEE82EE),
                 @"wheat":                  UIColorFromHexRGB(0xF5DEB3),
                 @"white":                  UIColorFromHexRGB(0xFFFFFF),
                 @"whitesmoke":             UIColorFromHexRGB(0xF5F5F5),
                 @"yellow":                 UIColorFromHexRGB(0xFFFF00),
                 @"yellowgreen":            UIColorFromHexRGB(0x9ACD32)
                 };
}

+ (UIColor*) colorWithRGB: (NSUInteger) rgb
{
    return UIColorFromHexRGB(rgb);
}

+ (UIColor*) colorWithRGBA: (NSUInteger) rgba
{
    return UIColorFromHexRGBA(rgba);
}

+ (UIColor*) colorWithHTML: (NSString*) html
{
    if (html == nil || [html length] < 1) {
        return nil;
    }
    
    UIColor *mappedColor = [colorMap objectForKey: html];
    if (mappedColor != nil) {
        return mappedColor;
    }
    
    if ([html characterAtIndex: 0] == '#' && ([html length] == 4 || [html length] == 7)) {
        // It's a hex string
        NSUInteger hex = 0;
        if (sscanf([html UTF8String], "#%x", &hex)) {
            if ([html length] == 4) {
                NSUInteger hex256 = 0;
                hex256 += (NSUInteger)((((hex>>8)&0xF)/15.0)*255.0)<<16;
                hex256 += (NSUInteger)((((hex>>4)&0xF)/15.0)*255.0)<<8;
                hex256 += (NSUInteger)((((hex>>0)&0xF)/15.0)*255.0)<<0;
                hex = hex256;
            }
            return UIColorFromHexRGB(hex);
        }
    }
    
    // Invalid HTML color
    return nil;
}

@end
