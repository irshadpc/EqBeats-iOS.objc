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
        
        CGFloat height = [self.text sizeWithFont: self.font
                               constrainedToSize: CGSizeMake(self.frame.size.width, CGFLOAT_MAX)
                                   lineBreakMode: self.lineBreakMode].height;
        if (self.maximumHeight > 0 && height > self.maximumHeight) {
            return @(self.maximumHeight);
        } else {
            return @(height);
        }
    }
}

@end
