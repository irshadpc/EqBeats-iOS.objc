//
//  EBPlaybackScrubControl.m
//  EqBeats
//
//  Created by Tyrone Trevorrow on 13/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import "EBPlaybackScrubControl.h"

@implementation EBPlaybackScrubControl {
    NSTimeInterval _elapsedWhenScrubStarted;
}
@synthesize trackColor = _trackColor;
@synthesize timeNormalColor = _timeNormalColor;
@synthesize timeHighlightedColor = _timeHighlightedColor;
@synthesize elapsed = _elapsed;
@synthesize duration = _duration;
@synthesize showsDuration = _showsDuration;
@synthesize showsElapsed = _showsElapsed;
@synthesize scrubbing = _scrubbing;

NS_INLINE void CommonInit(EBPlaybackScrubControl *self)
{
    self.showsDuration = YES;
    self.showsElapsed = YES;
}

- (id) init
{
    self = [super init];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (UIColor*) trackColor
{
    if (_trackColor == nil) {
        _trackColor = [UIColor colorWithHTML: @"#8239AB"];
    }
    return _trackColor;
}

- (UIColor*) timeNormalColor
{
    if (_timeNormalColor == nil) {
        _timeNormalColor = [UIColor colorWithWhite: 0.2 alpha: 1];
    }
    return _timeNormalColor;
}

- (UIColor*) timeHighlightedColor
{
    if (_timeHighlightedColor == nil) {
        _timeHighlightedColor = [UIColor whiteColor];
    }
    return _timeHighlightedColor;
}

- (void) setElapsed:(NSTimeInterval)elapsed
{
    _elapsed = elapsed;
    [self setNeedsDisplay];
}

- (void) setDuration:(NSTimeInterval)duration
{
    _duration = duration;
    [self setNeedsDisplay];
}

- (void) setShowsElapsed:(BOOL)showsElapsed
{
    _showsElapsed = showsElapsed;
    [self setNeedsDisplay];
}

- (void) setShowsDuration:(BOOL)showsDuration
{
    _showsDuration = showsDuration;
    [self setNeedsDisplay];
}

- (void) drawRect:(CGRect)rect
{
    // Setup.
    CGColorRef backColor = self.backgroundColor.CGColor;
    CGColorRef trackColor = self.trackColor.CGColor;
    UIFont *textFont = [UIFont boldSystemFontOfSize: 12.0f];
    
    double elapsedPercentage = 0;
    if (self.duration == 0) {
        elapsedPercentage = 0;
    } else {
        elapsedPercentage = self.elapsed / self.duration;
    }
    CGRect trackRect = CGRectMake(0, 0, round(rect.size.width * elapsedPercentage), rect.size.height);
//    CGRect notTrackRect = CGRectMake(trackRect.size.width, 0, rect.size.width - trackRect.size.width, rect.size.height);
    CGRect elapsedTextRect = CGRectMake(8, roundf((rect.size.height / 2.0) - (textFont.lineHeight / 2.0)), 100, textFont.lineHeight);
    CGRect durationTextRect = CGRectMake(rect.size.width - 108, roundf((rect.size.height / 2.0) - (textFont.lineHeight / 2.0)), 100, textFont.lineHeight);
    NSInteger durationMinutes = floorf(self.duration / 60.0);
    NSInteger durationSeconds = self.duration - (durationMinutes * 60);
    NSInteger elapsedMinutes = floor(self.elapsed / 60.0);
    NSInteger elapsedSeconds = self.elapsed - (elapsedMinutes * 60);
    NSString *durationText = [NSString stringWithFormat: @"%i:%02i", durationMinutes, durationSeconds];
    NSString *elapsedText = [NSString stringWithFormat: @"%i:%02i", elapsedMinutes, elapsedSeconds];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // Draw background.
    CGContextSetFillColorWithColor(ctx, backColor);
    CGContextFillRect(ctx, rect);
    
    // Draw track.
    CGContextSetFillColorWithColor(ctx, trackColor);
    CGContextFillRect(ctx, trackRect);
    
    // Draw labels.
    if (self.showsElapsed) {
        [self.timeNormalColor setFill];
        [elapsedText drawInRect: elapsedTextRect withFont: textFont lineBreakMode: NSLineBreakByTruncatingTail alignment: NSTextAlignmentLeft];
        CGContextSaveGState(ctx);
        CGContextClipToRect(ctx, trackRect);
        [self.timeHighlightedColor setFill];
        [elapsedText drawInRect: elapsedTextRect withFont: textFont lineBreakMode: NSLineBreakByTruncatingTail alignment: NSTextAlignmentLeft];
        CGContextRestoreGState(ctx);
    }
    if (self.showsDuration) {
        [self.timeNormalColor setFill];
        [durationText drawInRect: durationTextRect withFont: textFont lineBreakMode: NSLineBreakByTruncatingTail alignment: NSTextAlignmentRight];
        CGContextSaveGState(ctx);
        CGContextClipToRect(ctx, trackRect);
        [self.timeHighlightedColor setFill];
        [durationText drawInRect: durationTextRect withFont: textFont lineBreakMode: NSLineBreakByTruncatingTail alignment: NSTextAlignmentRight];
        CGContextRestoreGState(ctx);
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan: touches withEvent: event];
    _scrubbing = YES;
    _elapsedWhenScrubStarted = self.elapsed;
    [self updateElapsedWithTouch: [touches anyObject]];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved: touches withEvent: event];
    // TODO: Half scrubbing, quarter scrubbing, fine scrubbing.
    [self updateElapsedWithTouch: [touches anyObject]];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded: touches withEvent: event];
    [self updateElapsedWithTouch: [touches anyObject]];
    [self sendActionsForControlEvents: UIControlEventValueChanged];
    _scrubbing = NO;
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled: touches withEvent: event];
    _scrubbing = NO;
    self.elapsed = _elapsedWhenScrubStarted;
}

- (void) updateElapsedWithTouch: (UITouch*) touch
{
    CGPoint pointInView = [touch locationInView: self];
    double newElapsed = (pointInView.x / self.frame.size.width) * self.duration;
    // Snap to edges
    if (pointInView.x < 8) {
        newElapsed = 0;
    } else if (pointInView.x > self.frame.size.width - 8) {
        newElapsed = self.duration;
    }
    self.elapsed = newElapsed;
}

@end
