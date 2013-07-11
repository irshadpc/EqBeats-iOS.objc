//
//  EBFeaturedViewController.m
//  EqBeats
//
//  Created by Tyrone Trevorrow on 2/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import "EBFeaturedViewController.h"
#import "EBAPI.h"

@interface EBFeaturedViewController ()
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (copy, nonatomic) NSArray *featured;
@property (copy, nonatomic) NSArray *latest;
@property (copy, nonatomic) NSArray *random;
@property (readonly, nonatomic) NSArray *tracks;
@end

@implementation EBFeaturedViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.featured = @[];
    self.latest = @[];
    self.random = @[];
    [self.refreshControl addTarget: self action: @selector(refreshControlChanged:) forControlEvents: UIControlEventValueChanged];
    if (EBDeviceSystemMajorVersion() >= 7) {
        self.segmentedControl.tintColor = [UIColor whiteColor];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self loadLatest];
    [self loadFeatured];
}

- (void) loadBySelectedIndex
{
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0: // Featured
            [self loadFeatured];
            break;
        case 1:
            [self loadLatest];
            break;
        case 2:
            [self loadRandom];
            break;
        default:
            break;
    }
}

- (void) loadFeatured
{
    [EBAPI getFeaturedTracksCompletion:^(NSArray *objects, NSError *error) {
        if (error == nil && objects != nil) {
            self.featured = objects;
            [self setNeedsReload];
        }
    }];
}

- (void) loadLatest
{
    [EBAPI getLatestTracksCompletion:^(NSArray *objects, NSError *error) {
        if (error == nil && objects != nil) {
            self.latest = objects;
            [self setNeedsReload];
        }
    }];
}

- (void) loadRandom
{
    [EBAPI getRandomTracksCompletion:^(NSArray *objects, NSError *error) {
        if (error == nil && objects != nil) {
            self.random = objects;
            [self setNeedsReload];
        }
    }];
}

- (NSArray*) tracks
{
    return @[self.featured, self.latest, self.random][self.segmentedControl.selectedSegmentIndex];
}

- (void) segmentedControlChanged:(id)sender
{
    if (self.tracks.count == 0) {
        [self loadBySelectedIndex];
    }
    [self setNeedsReload];
}

- (void) refreshControlChanged: (UIRefreshControl*) sender
{
    if (sender.refreshing) {
        [self loadBySelectedIndex];
    }
}

#pragma mark - Table View

- (EBTrack*) trackForIndexPath:(NSIndexPath *)indexPath
{
    return self.tracks[indexPath.row];
}

- (NSArray*) tracksForQueueAtIndexPath:(NSIndexPath *)indexPath
{
    return self.tracks;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tracks.count;
}

@end
