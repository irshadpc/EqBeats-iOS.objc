//
//  EBVerticalExpandingLabel.m
//  EqBeats
//
//  Created by Tyrone Trevorrow on 12/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import "EBVerticalExpandingLabel.h"

@implementation EBVerticalExpandingLabel

- (NSNumber*) desiredHeight
{
    if (self.text == nil) {
        return 0;
    } else {
        return @([self.text sizeWithFont: self.font
                       constrainedToSize: CGSizeMake(self.frame.size.width, CGFLOAT_MAX)
                           lineBreakMode: self.lineBreakMode].height);
    }
}

@end
