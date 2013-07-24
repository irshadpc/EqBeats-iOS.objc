//
//  EBLaunchViewController.m
//  EqBeats
//
//  Created by Tyrone Trevorrow on 2/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import "EBLaunchViewController.h"
#import "EBLaunchBackgroundView.h"
#import "SDImageCache.h"
#import "EBResourcesController.h"
#import "EBArrayUtility.h"

@interface EBLaunchViewController () <EBLaunchBackgroundViewDataSource>
@property (nonatomic, strong) NSMutableArray *launchImages;
@end

@interface SDImageCache ()
@property (strong, nonatomic) NSString *diskCachePath; // Ghetto as fuck.
@end

@implementation EBLaunchViewController {
    NSInteger _imageCount;
}

- (BOOL) prefersStatusBarHidden
{
    return YES;
}

- (void) reloadLaunchImages
{
    NSURL *albumArtPath = [[[NSBundle mainBundle] bundleURL] URLByAppendingPathComponent: @"albumart"];
    NSFileManager *fm = [NSFileManager new];
    NSArray *bundledArt = [fm contentsOfDirectoryAtURL: albumArtPath includingPropertiesForKeys: nil options: 0 error: nil];
    NSURL *cachePath = [NSURL fileURLWithPath:[[EBTrackArtworkDownloadManager sharedManager].imageCache diskCachePath] isDirectory: YES];
    NSArray *cachedArt = [fm contentsOfDirectoryAtURL: cachePath includingPropertiesForKeys: nil options:0 error: nil];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity: bundledArt.count + cachedArt.count];
    [array addObjectsFromArray: bundledArt];
    [array addObjectsFromArray: cachedArt];
    // Shuffle
    [EBArrayUtility shuffleArray: array];
    self.launchImages = array;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self.navigationController setNavigationBarHidden: YES animated: animated];
    [self.launchView reloadData];
}

- (NSURL*) imageForLaunchBackgroundView:(EBLaunchBackgroundView *)view
{
    if (self.launchImages.count == 0) {
        [self reloadLaunchImages];
    }
    NSURL *url = [self.launchImages lastObject];
    [self.launchImages removeLastObject];
    return url;
}

- (IBAction)tapAction:(id)sender
{
    [self performSegueWithIdentifier: @"PushToTabBarController" sender: self];
}

@end
