//
//  EBMainTabBarController.m
//  EqBeats
//
//  Created by Tyrone Trevorrow on 2/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import "EBMainTabBarController.h"
#import "EBResourcesController.h"
#import "EBTabBarView.h"
#import "UIView+LoadFromNib.h"
#import "EBAudioController.h"
#import "EBModel.h"
#import "EBTrack.h"
#import "EBUser.h"

@interface EBMainTabBarController () <UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *rewindButton;
@property (weak, nonatomic) IBOutlet UIButton *playPauseButton;
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;
@property (strong, nonatomic) EBTabBarView *customTabBarView;
@end

@implementation EBMainTabBarController

- (void) viewDidLoad
{
    [super viewDidLoad];
    for (UITabBarItem *item in self.tabBar.items) {
        [item setFinishedSelectedImage: item.image withFinishedUnselectedImage: item.image];
    }
    
    self.moreNavigationController.delegate = self;
    self.customTabBarView = [EBTabBarView loadFromNibName: nil bundle: nil filesOwner: self];
    [self.tabBar addSubview: self.customTabBarView];
    [self.tabBar bringSubviewToFront: self.customTabBarView];
    [self.moreNavigationController.navigationBar setBackgroundImage: [UIImage imageNamed: @"NavigationBarBackground.png"] forBarMetrics: UIBarMetricsDefault];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self.tabBar bringSubviewToFront: self.customTabBarView];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(updatePlayingItem) name: EBAudioControllerCurrentItemChangedNotification object: nil];
}

- (void) updatePlayingItem
{
    EBTrack *currentTrack = [EBModel sharedModel].audioController.currentTrack;
    if (currentTrack == nil) {
        self.customTabBarView.songText = nil;
        self.customTabBarView.artistLabel.text = nil;
        self.customTabBarView.songArtView.image = nil;
    } else {
        self.customTabBarView.songText = currentTrack.title;
        self.customTabBarView.artistLabel.text = currentTrack.artist.name;
        [EBResourcesController setImageForImageView: self.customTabBarView.songArtView
                                              track: currentTrack
                                            quality: EBTrackArtQualityThumb];
    }
}

#pragma mark - Button Actions

- (IBAction) nextButtonAction: (id) sender
{
    
}

- (IBAction) previousButtonAction: (id) sender
{
    
}

- (IBAction) playPauseButtonAction: (id) sender
{
    
}

- (IBAction) toTabBarControlsAction: (id) sender
{
    
}

- (IBAction) toPlaybackControlsAction: (id) sender
{
    
}

- (IBAction) tabButtonAction: (id) sender
{
    
}

@end
