//
//  EBTracksViewController.m
//  EqBeats
//
//  Created by Tyrone Trevorrow on 2/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import "EBTracksViewController.h"
#import "EBPlaylistsViewController.h"
#import "EBNavigationController.h"
#import "EBAppDelegate.h"
#import "EBUser.h"
#import "EBArrayUtility.h"

@interface EBTracksViewController () {
    BOOL _needsReload;
}

@end

@implementation EBTracksViewController
@synthesize trackCellNib = _trackCellNib;
@synthesize trackListOperationsCell = _trackListOperationsCell;

- (UINib*) trackCellNib
{
    if (_trackCellNib == nil) {
        _trackCellNib = [UINib nibWithNibName: @"TrackCell" bundle: nil];
    }
    return _trackCellNib;
}

- (EBTrackListOperationsCell*) trackListOperationsCell
{
    if (_trackListOperationsCell == nil) {
        UINib *nib = [UINib nibWithNibName: @"EBTrackListOperationsCell" bundle: nil];
        _trackListOperationsCell = [[nib instantiateWithOwner: self options: nil] firstObject];
    }
    return _trackListOperationsCell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.trackCellNib != nil) {
        [self.tableView registerNib: self.trackCellNib forCellReuseIdentifier: @"EBTrackCell"];
    }
    if (self.playlist) {
        self.title = @"Add Tracks";
        self.pickedIndexes = [NSMutableIndexSet new];
        self.navigationItem.prompt = [NSString stringWithFormat: @"Select Tracks to Add to %@", self.playlist.name];
        self.doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target: self action: @selector(doneButtonAction:)];
        self.navigationItem.rightBarButtonItem = self.doneButtonItem;
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

- (void) doneButtonAction: (id) sender
{
    NSArray *tracks = [self.tracksToAdd objectsAtIndexes: self.pickedIndexes];
    if (tracks.count > 0) {
        for (EBTrack *track in tracks) {
            [self.playlist addTracksObject: track];
        }
        if (![self.playlist isInserted]) {
            self.playlist.sortIndex = [[[EBModel allPlaylists] lastObject] sortIndex] + 1;
            [EBModel.sharedModel.mainThreadObjectContext insertObject: self.playlist];
        }
        [EBModel.sharedModel.mainThreadObjectContext save: nil];
    }
    [self.presentingViewController dismissViewControllerAnimated: YES completion: nil];
}

- (void) addToPlaylistButtonAction:(id)sender
{
    EBPlaylistsViewController *playlistsVC = [self.storyboard instantiateViewControllerWithIdentifier: @"EBPlaylistsViewController"];
    playlistsVC.tracksToAdd = [self allTracks];
    EBNavigationController *navVC = [[EBNavigationController alloc] initWithRootViewController: playlistsVC];
    [self presentViewController: navVC animated: YES completion: nil];
}

- (void) shufflePlayButtonAction:(id)sender
{
    NSMutableArray *tracks = [[self allTracks] mutableCopy];
    [EBArrayUtility shuffleElementsInArray: tracks afterIndex: 0];
    [EBModel.sharedModel.audioController setPlaybackQueue: tracks queueIndex: 0];
    UIViewController *player = [self.storyboard instantiateViewControllerWithIdentifier: @"NowPlaying"];
    [EBAppDelegate.appDelegate.navigationController pushViewController: player animated: YES];
    [EBModel.sharedModel.audioController play];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tracksToAdd.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self trackCellForIndexPath: indexPath];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tracksToAdd == nil) {
        NSArray *tracks = [self tracksForQueueAtIndexPath: indexPath];
        EBTrack *track = [self trackForIndexPath: indexPath];
        NSInteger index = [tracks indexOfObject: track];
        NSAssert(index != NSNotFound, @"track: %@ not found in result from tracksForQueueAtIndexPath!", track);
        [EBModel.sharedModel.audioController setPlaybackQueue: tracks queueIndex: index];
        UIViewController *player = [self.storyboard instantiateViewControllerWithIdentifier: @"NowPlaying"];
        [EBAppDelegate.appDelegate.navigationController pushViewController: player animated: YES];
        [EBModel.sharedModel.audioController play];
    } else {
        if ([self.pickedIndexes containsIndex: indexPath.row]) {
            [self.pickedIndexes removeIndex: indexPath.row];
        } else {
            [self.pickedIndexes addIndex: indexPath.row];
        }
        [self.tableView reloadRowsAtIndexPaths: @[indexPath] withRowAnimation: UITableViewRowAnimationNone];
    }
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
    
    if (self.tracksToAdd != nil) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        if ([self.pickedIndexes containsIndex: indexPath.row]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    return cell;
}

- (EBTrack*) trackForIndexPath:(NSIndexPath *)indexPath
{
    // Override this
    return self.tracksToAdd[indexPath.row];
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

- (NSArray*) allTracks
{
    // Override this
    return self.tracksToAdd;
}

@end
