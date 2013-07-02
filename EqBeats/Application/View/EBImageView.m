//
//  EBImageView.m
//  EqBeats
//
//  Created by Tyrone Trevorrow on 2/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import "EBImageView.h"

@implementation EBImageView

- (NSNumber*) desiredHeight
{
    return @(self.frame.size.height);
}

- (NSNumber*) desiredWidth
{
    return @(self.frame.size.width);
}

@end
