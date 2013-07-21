//
//  EBPlaylistsViewController.m
//  EqBeats
//
//  Created by Tyrone Trevorrow on 2/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import "EBPlaylistsViewController.h"
#import "EBPlaylistViewController.h"
#import "EBModel.h"
#import "EBPlaylist.h"
#import "EBTrack.h"
#import "EBShadowedTextField.h"
#import "EBPlaylistCell.h"

@interface EBPlaylistsViewController ()
@property (nonatomic, copy) NSArray *playlists;
@end

@implementation EBPlaylistsViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    self.playlists = [EBModel allPlaylists];
    [self.tableView reloadData];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.playlists.count == 0) {
        return 1;
    }
    return self.playlists.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.playlists.count == 0) {
        return [tableView dequeueReusableCellWithIdentifier: @"AddPlaylistCell"];
    }
    EBPlaylistCell *cell = [tableView dequeueReusableCellWithIdentifier: @"EBPlaylistCell"];
    if (self.tracksToAdd != nil) {
        cell.contextButton.hidden = YES;
    } else if (cell.accessoryView != cell.contextButton) {
        cell.contextButton.hidden = NO;
        [cell.contextButton addTarget: self action: @selector(contextButtonAction:) forControlEvents: UIControlEventTouchUpInside];
    }
    EBPlaylist *playlist = self.playlists[indexPath.row];
    cell.nameLabel.text = playlist.name;
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (playlist.tracks.count == 0) {
        cell.tracksLabel.text = @"Empty";
    } else {
        cell.tracksLabel.text = [NSString stringWithFormat: @"%i %@", playlist.tracks.count, playlist.tracks.count == 1 ? @"track" : @"tracks"];
    }
    return cell;
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        EBPlaylist *playlist = self.playlists[indexPath.row];
        [EBModel.sharedModel.mainThreadObjectContext deleteObject: playlist];
        [EBModel.sharedModel.mainThreadObjectContext save: nil];
        self.playlists = [EBModel allPlaylists];
        if (self.playlists.count != 0) {
            [self.tableView deleteRowsAtIndexPaths: @[indexPath] withRowAnimation: UITableViewRowAnimationAutomatic];
        } else {
            [self.tableView reloadRowsAtIndexPaths: @[indexPath] withRowAnimation: UITableViewRowAnimationAutomatic];
        }
    }
}

- (void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    EBPlaylist *sourcePlaylist = self.playlists[sourceIndexPath.row];
    EBPlaylist *destinationPlaylist = self.playlists[sourceIndexPath.row];
    NSInteger x = sourcePlaylist.sortIndex;
    sourcePlaylist.sortIndex = destinationPlaylist.sortIndex;
    destinationPlaylist.sortIndex = x;
    [EBModel.sharedModel.mainThreadObjectContext save: nil];
    self.playlists = [EBModel allPlaylists];
    [self.tableView reloadData];
}

- (void) contextButtonAction: (id) sender
{
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString: @"PlaylistCellPushSegue"]) {
        UITableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell: cell];
        EBPlaylist *playlist = self.playlists[indexPath.row];
        [segue.destinationViewController setPlaylist: playlist];
    }
}

@end
