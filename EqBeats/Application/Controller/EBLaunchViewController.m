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
    EBLog(@"Bundled art:%@", bundledArt);
    EBLog(@"Cached art:%@", cachedArt);
    [array addObjectsFromArray: bundledArt];
    [array addObjectsFromArray: cachedArt];
    // Shuffle
    NSInteger count = array.count;
    for (int i = 0; i < count; i++) {
        NSInteger index = arc4random_uniform(count-i) + i;
        [array exchangeObjectAtIndex: i withObjectAtIndex: index];
    }
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
