//
//  EBPlayerViewController.m
//  EqBeats
//
//  Created by Tyrone Trevorrow on 2/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "EBAudioController.h"
#import "EBResourcesController.h"
#import "EBModel.h"
#import "EBUser.h"
#import "EBTrack.h"
#import "EBPlayerViewController.h"
#import "EBPlaybackScrubControl.h"
#import "EBImageView.h"
#import "MarqueeLabel.h"

@interface EBPlayerViewController ()
@property (strong, nonatomic) IBOutlet EBPlaybackScrubControl *scrubControl;
@property (strong, nonatomic) IBOutlet MPVolumeView *volumeView;
@property (strong, nonatomic) IBOutlet UISlider *fakeVolumeView;
@property (strong, nonatomic) IBOutlet UIButton *previousButton;
@property (strong, nonatomic) IBOutlet UIButton *playPauseButton;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet EBImageView *artworkView;
@property (strong, nonatomic) IBOutlet UILabel *artistLabel;
@property (strong, nonatomic) IBOutlet MarqueeLabel *songLabel;

@end

@implementation EBPlayerViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
#ifdef TARGET_IPHONE_SIMULATOR
    self.fakeVolumeView.hidden = NO;
#endif
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(playbackHeadMoved) name:EBAudioControllerPlaybackHeadMovedNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(currentItemChanged) name:EBAudioControllerCurrentItemChangedNotification object: nil];
    [self updateButtons];
    [self updateSlider];
    [self updateLabels];
}

- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleBlackOpaque;
}

- (BOOL) extendedLayoutIncludesOpaqueBars
{
    return YES;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateEverything];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (void) updateEverything
{
    [self updateButtons];
    [self updateSlider];
    [self updateArtwork];
    [self updateLabels];
}

- (void) updateSlider
{
    if (!self.scrubControl.scrubbing) {
        self.scrubControl.duration = EBModel.sharedModel.audioController.duration.doubleValue;
        self.scrubControl.elapsed = EBModel.sharedModel.audioController.elapsedTime.doubleValue;
    }
}

- (void) updateLabels
{
    self.artistLabel.text = EBModel.sharedModel.audioController.currentTrack.artist.name;
    self.songLabel.text = EBModel.sharedModel.audioController.currentTrack.title;
}

- (void) updateButtons
{
    self.previousButton.enabled = EBModel.sharedModel.audioController.hasPreviousItem;
    self.nextButton.enabled = EBModel.sharedModel.audioController.hasNextItem;
    
    EBAudioController *ac = EBModel.sharedModel.audioController;
    if (ac.playing) {
        [self.playPauseButton setImage: [UIImage imageNamed: @"Pause"] forState: UIControlStateNormal];
    } else {
        [self.playPauseButton setImage: [UIImage imageNamed: @"Play"] forState: UIControlStateNormal];
    }
}

- (void) updateArtwork
{
    [EBResourcesController setImageForImageView: self.artworkView track: EBModel.sharedModel.audioController.currentTrack quality: EBTrackArtQualityFull];
}

- (void) playbackHeadMoved
{
    [self updateSlider];
}

- (void) currentItemChanged
{
    [self updateEverything];
}

#pragma mark - Actions

- (IBAction)backButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated: YES];
}

- (IBAction)queueButtonAction:(id)sender
{

}

- (IBAction)previousButtonAction:(id)sender
{
    [[EBModel sharedModel].audioController skipBackwards];
}

- (IBAction)playPauseButtonAction:(id)sender
{
    [[EBModel sharedModel].audioController togglePlayPause];
}

- (IBAction)nextButtonAction:(id)sender
{
    [[EBModel sharedModel].audioController skipForwards];
}

#pragma mark - Audio Stuff



@end
