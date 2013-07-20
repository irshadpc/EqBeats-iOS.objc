//
//  EBShadowedTextField.m
//  EqBeats
//
//  Created by Tyrone Trevorrow on 2/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import "EBShadowedTextField.h"

@implementation EBShadowedTextField

- (void) drawTextInRect:(CGRect)rect
{
    if (self.shadowOffset.width == 0 && self.shadowOffset.height == 0) {
        return [super drawTextInRect: rect];
    }
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGContextSetShadowWithColor(ctx, self.shadowOffset, 0, self.shadowColor.CGColor);
    [super drawTextInRect: rect];
    CGContextRestoreGState(ctx);
}

@end
