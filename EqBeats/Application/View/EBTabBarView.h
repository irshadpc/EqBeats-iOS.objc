//
//  EBTabBarView.h
//  EqBeats
//
//  Created by Tyrone Trevorrow on 1/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MarqueeLabel, EBImageView;

@interface EBTabBarView : UIView
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *contentView;
@property (nonatomic, strong) IBOutlet UIButton *featuredButton;
@property (nonatomic, strong) IBOutlet UIButton *playlistsButton;
@property (nonatomic, strong) IBOutlet UIButton *searchButton;
@property (nonatomic, strong) IBOutlet UIButton *moreButton;
@property (nonatomic, strong) IBOutlet UIButton *radioButton;
@property (nonatomic, strong) IBOutlet UILabel *artistLabel;
@property (nonatomic, strong) IBOutlet MarqueeLabel *songLabel;
@property (nonatomic, strong) IBOutlet EBImageView *songArtView;
@property (nonatomic, strong) IBOutlet UIView *shadowView;

@property (nonatomic, copy) NSString *songText;

@end
