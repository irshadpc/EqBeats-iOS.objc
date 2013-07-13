//
//  EBPlaybackScrubControl.h
//  EqBeats
//
//  Created by Tyrone Trevorrow on 13/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EBPlaybackScrubControl : UIControl
@property (nonatomic, strong) UIColor *trackColor;
@property (nonatomic, strong) UIColor *timeNormalColor;
@property (nonatomic, strong) UIColor *timeHighlightedColor;

@property (nonatomic, assign) BOOL showsElapsed;
@property (nonatomic, assign) BOOL showsDuration;
@property (nonatomic, assign, readonly, getter = isScrubbing) BOOL scrubbing;

@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) NSTimeInterval elapsed;

@end
