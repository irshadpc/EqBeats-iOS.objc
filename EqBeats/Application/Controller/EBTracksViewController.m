//
//  EBTracksViewController.m
//  EqBeats
//
//  Created by Tyrone Trevorrow on 2/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import "EBTracksViewController.h"
#import "EBUser.h"

@interface EBTracksViewController () {
    BOOL _needsReload;
}

@end

@implementation EBTracksViewController
@synthesize trackCellNib = _trackCellNib;

- (UINib*) trackCellNib
{
    if (_trackCellNib == nil) {
        _trackCellNib = [UINib nibWithNibName: @"TrackCell" bundle: nil];
    }
    return _trackCellNib;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.trackCellNib != nil) {
        [self.tableView registerNib: self.trackCellNib forCellReuseIdentifier: @"EBTrackCell"];
    }
}

- (void) setNeedsReload
{
    _needsReload = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget: self selector: @selector(_doReload) object:nil];
    [self performSelector: @selector(_doReload) withObject: nil afterDelay: 1.0/60.0 inModes: @[ NSRunLoopCommonModes ]];
}

- (void) _doReload
{
    if (_needsReload) {
        [self reloadData];
        _needsReload = NO;
    }
}

- (void) reloadData
{
    _needsReload = NO;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self trackCellForIndexPath: indexPath];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (EBTrackCell*) trackCellForIndexPath:(NSIndexPath *)indexPath
{
    EBTrackCell *cell = [self.tableView dequeueReusableCellWithIdentifier: @"EBTrackCell"];
    EBTrack *track = [self trackForIndexPath: indexPath];
    if (cell.backgroundView == nil) {
        cell.backgroundView = [[UIView alloc] initWithFrame: cell.contentView.bounds];
    }
    if (indexPath.row % 2 == 0) {
        [cell.backgroundView setBackgroundColor: @"#fcf6fd".color];
    } else {
        [cell.backgroundView setBackgroundColor: [UIColor whiteColor]];
    }
    
    cell.titleLabel.text = track.title;
    cell.detailTitleLabel.text = track.artist.name;
    [EBResourcesController setImageForImageView: cell.artworkView track: track quality: EBTrackArtQualityThumb];
    
    return cell;
}

- (EBTrack*) trackForIndexPath:(NSIndexPath *)indexPath
{
    // Abstract. Override this.
    return nil;
}

- (NSArray*) tracksForQueueAtIndexPath:(NSIndexPath *)indexPath
{
    // Near-abstract.  Override this.
    id track = [self trackForIndexPath: indexPath];
    if (track) {
        return @[track];
    }
    return nil;
}

@end
