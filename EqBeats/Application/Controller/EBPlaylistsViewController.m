//
//  EBPlaylistsViewController.m
//  EqBeats
//
//  Created by Tyrone Trevorrow on 2/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import "EBPlaylistsViewController.h"
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
    return self.playlists.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EBPlaylistCell *cell = [tableView dequeueReusableCellWithIdentifier: @"EBPlaylistCell"];
    if (self.tracksToAdd != nil) {
        cell.contextButton.hidden = YES;
    } else if (cell.accessoryView != cell.contextButton) {
        cell.contextButton.hidden = NO;
        [cell.contextButton addTarget: self action: @selector(contextButtonAction:) forControlEvents: UIControlEventTouchUpInside];
    }
    EBPlaylist *playlist = self.playlists[indexPath.row];
    cell.nameLabel.text = playlist.name;
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

- (void) contextButtonAction: (id) sender
{
    
}

@end
