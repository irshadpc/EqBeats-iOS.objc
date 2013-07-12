//
//  EBTabBarView.m
//  EqBeats
//
//  Created by Tyrone Trevorrow on 1/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import "EBTabBarView.h"
#import "MarqueeLabel.h"
#import "EBImageView.h"

@implementation EBTabBarView

- (void) awakeFromNib
{
    [super awakeFromNib];
    [self.contentView setBackgroundColor: [UIColor clearColor]];
    [self.scrollView addSubview: self.contentView];
    [self.scrollView setContentSize: self.contentView.frame.size];
    CALayer *shadowLayer = self.songArtView.layer;
    shadowLayer.cornerRadius = 3;
    shadowLayer.shadowColor = UIColor.blackColor.CGColor;
    shadowLayer.shadowPath = [UIBezierPath bezierPathWithRoundedRect: self.songArtView.bounds cornerRadius:3].CGPath;
    shadowLayer.shadowOffset = CGSizeMake(0,1);
    shadowLayer.shadowOpacity = 0.6;
    shadowLayer.shouldRasterize = YES;
    shadowLayer.shadowRadius = 2;
    shadowLayer.rasterizationScale = UIScreen.mainScreen.scale;
    shadowLayer.masksToBounds = false;
    self.songArtView.layer.cornerRadius = 3;
}

- (void) setSongText:(NSString *)songText
{
    _songText = songText.copy;
    CGSize maxSize = CGSizeMake(CGFLOAT_MAX, self.songLabel.frame.size.height);
    CGSize desiredSize = [_songText sizeWithFont: self.songLabel.font
                               constrainedToSize: maxSize
                                   lineBreakMode: self.songLabel.lineBreakMode];
    if (desiredSize.width >= self.songLabel.frame.size.width - 20) {
        self.songLabel.marqueeType = MLContinuous;
        self.songLabel.textAlignment = NSTextAlignmentCenter;
    } else {
        self.songLabel.marqueeType = MLLeftRight;
        self.songLabel.textAlignment = NSTextAlignmentLeft;
    }
    self.songLabel.text = _songText;
}

@end
