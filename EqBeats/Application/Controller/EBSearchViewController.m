//
//  EBSearchViewController.m
//  EqBeats
//
//  Created by Tyrone Trevorrow on 2/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import "EBSearchViewController.h"
#import "EBImageView.h"
#import "EBUserCell.h"
#import "EBAPI.h"
#import "EBUser.h"
#import "EBTrack.h"
#import "EBPlaylist.h"
#import "SDAnchorView.h"

@interface EBSearchViewController ()
@property (nonatomic, copy) NSArray *searchResults;
@property (nonatomic, strong) UINib *userNib;
@property (nonatomic, readonly) UITableView *searchTableView;
@property (nonatomic, readonly) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableIndexSet *pickedIndexes;
@end

@implementation EBSearchViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.userNib = [UINib nibWithNibName: @"UserCell" bundle: nil];
    if (self.playlist) {
        self.pickedIndexes = [NSMutableIndexSet new];
        self.navigationItem.prompt = [NSString stringWithFormat: @"Select Tracks to Add to %@", self.playlist.name];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target: self action: @selector(doneButtonAction:)];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView registerNib: self.userNib forCellReuseIdentifier: @"EBUserCell"];
    [self setNeedsReload];
}

- (void) reloadData
{
    [super reloadData];
    [self.searchTableView reloadData];
}

- (UITableView*) searchTableView
{
    return self.searchDisplayController.searchResultsTableView;
}

- (UISearchBar*) searchBar
{
    return self.searchDisplayController.searchBar;
}

- (void) doneButtonAction: (id) sender
{
    NSArray *tracks = [self.searchResults objectsAtIndexes: self.pickedIndexes];
    if (tracks.count > 0) {
        for (EBTrack *track in tracks) {
            [self.playlist addTracksObject: track];
        }
    }
    [self.presentingViewController dismissViewControllerAnimated: YES completion: nil];
}

#pragma mark - Search Controller

- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    self.searchResults = nil;
    [self setNeedsReload];
    [self performSearchDelayed];
    return NO;
}

- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self performSearchDelayed];
    return NO;
}

- (void) searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    [tableView registerNib: self.userNib forCellReuseIdentifier: @"EBUserCell"];
    [tableView registerNib: self.trackCellNib forCellReuseIdentifier: @"EBTrackCell"];
}

//- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
//{
//    self.searchResults = nil;
//    [self setNeedsReload];
//}

- (void) performSearchDelayed
{
    [NSObject cancelPreviousPerformRequestsWithTarget: self selector: @selector(performSearch) object: nil];
    [self performSelector: @selector(performSearch) withObject: nil afterDelay: 0.75];
}

- (void) performSearch
{
    if (self.searchBar.text.length < 3) {
        return;
    }
    self.searchResults = nil;
    [self setNeedsReload];
    switch (self.searchBar.selectedScopeButtonIndex) {
        case 0: {
            [EBAPI getTracksWithSearchQuery: self.searchBar.text
                                 completion:^(NSArray *objects, NSError *error) {
                                     self.searchResults = objects;
                                     [self setNeedsReload];
                                 }];
            break;
        }
        case 1: {
            [EBAPI getUserWithSearchQuery: self.searchBar.text
                                 completion:^(NSArray *objects, NSError *error) {
                                     self.searchResults = objects;
                                     [self setNeedsReload];
                                 }];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Table View

- (EBTrack*) trackForIndexPath:(NSIndexPath *)indexPath
{
    return self.searchResults[indexPath.row];
}

- (NSArray*) tracksForQueueAtIndexPath:(NSIndexPath *)indexPath
{
    return self.searchResults;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResults.count;
}

- (EBUserCell*) tableView: (UITableView*) tableView userCellForRow: (NSInteger) row
{
    EBUserCell *cell = (id)[tableView dequeueReusableCellWithIdentifier: @"EBUserCell"];
    EBUser *artist = self.searchResults[row];
    
    cell.nameLabel.text = artist.name;
    cell.descriptionLabel.text = artist.plainDetail;
    return cell;
}

- (EBTrackCell*) trackCellForIndexPath:(NSIndexPath *)indexPath
{
    EBTrackCell *cell = [super trackCellForIndexPath: indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (self.playlist) {
        if ([self.pickedIndexes containsIndex: indexPath.row]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    return cell;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchBar.selectedScopeButtonIndex == 0) {
        return [super tableView: tableView cellForRowAtIndexPath: indexPath];
    } else {
        return [self tableView: tableView userCellForRow: indexPath.row];
    }
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass: [EBUserCell class]]) {
        EBUserCell *userCell = (id)cell;
        EBUser *artist = self.searchResults[indexPath.row];
        [userCell.avatarImageView loadImageFromURL: [NSURL URLWithString: artist.avatar]
                                  placeHolderImage: nil
                                        completion: nil];
        [userCell.layoutView setNeedsLayout];
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.playlist) {
        if ([self.pickedIndexes containsIndex: indexPath.row]) {
            [self.pickedIndexes removeIndex: indexPath.row];
        } else {
            [self.pickedIndexes addIndex: indexPath.row];
        }
        [self.searchTableView reloadRowsAtIndexPaths: @[indexPath] withRowAnimation: UITableViewRowAnimationNone];
        [self.tableView reloadRowsAtIndexPaths: @[indexPath] withRowAnimation: UITableViewRowAnimationNone];
        if ([self.searchDisplayController isActive]) {
            [self.searchDisplayController setActive: NO animated: YES];
            CGPoint p = self.searchTableView.contentOffset;
            p.y += 32 + 44;
            [self.tableView setContentOffset: p];
        }
        return;
    }
    if (self.searchBar.selectedScopeButtonIndex == 0) {
        [super tableView: tableView didSelectRowAtIndexPath: indexPath];
    } else {
        // It's a user, do different stuff
    }
}

@end
