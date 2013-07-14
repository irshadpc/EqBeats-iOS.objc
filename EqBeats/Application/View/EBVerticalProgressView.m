//
//  EBVerticalProgressView.m
//  EqBeats
//
//  Created by Tyrone Trevorrow on 14/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import "EBVerticalProgressView.h"

@interface EBVerticalProgressLayer : CALayer
@property (nonatomic, assign, readwrite) CGFloat progress;
@property (nonatomic, strong) UIColor *trackColor;
@end

@implementation EBVerticalProgressLayer
@dynamic progress;

+ (BOOL) needsDisplayForKey:(NSString *)key
{
    if ([key isEqualToString: @"progress"]) {
        return YES;
    } else if ([key isEqualToString: @"trackColor"]) {
        return YES;
    } else {
        return [super needsDisplayForKey: key];
    }
}

- (id<CAAction>) actionForKey:(NSString *)event
{
    if ([event isEqualToString: @"progress"]) {
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath: event];
        anim.fromValue = [self.presentationLayer valueForKey: event];
        
        return anim;
    }
    return [super actionForKey: event];
}

- (void) drawInContext:(CGContextRef)ctx
{
    CGRect rect = CGContextGetClipBoundingBox(ctx);
    CGFloat progress = [[self presentationLayer] progress];
    CGColorRef trackColor = [[[self modelLayer] trackColor] CGColor];
    CGRect progressRect = CGRectMake(0, 0, rect.size.width, progress * rect.size.height);
    // Draw background
    CGContextSetFillColorWithColor(ctx, self.backgroundColor);
    CGContextFillRect(ctx, rect);
    
    // Draw progress
    CGContextSetFillColorWithColor(ctx, trackColor);
    CGContextFillRect(ctx, progressRect);
}

@end

@implementation EBVerticalProgressView

+ (Class) layerClass
{
    return [EBVerticalProgressLayer class];
}

- (CGFloat) progress
{
    return [(id)self.layer progress];
}

- (void) setProgress:(CGFloat)progress
{
    [self.layer setValue: @(progress) forKey: @"progress"];
}

- (UIColor*) trackColor
{
    return [(id)self.layer trackColor];
}

- (void) setTrackColor:(UIColor *)trackColor
{
    [self.layer setValue: trackColor forKey: @"trackColor"];
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    [self.layer setContentsScale: [UIScreen mainScreen].scale];
}

- (void) didMoveToSuperview
{
    [super didMoveToSuperview];
    if (self.superview) {
        [self.layer setNeedsDisplay];
    }
}

@end
