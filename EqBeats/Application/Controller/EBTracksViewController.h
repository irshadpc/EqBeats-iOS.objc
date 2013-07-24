//
//  EBTracksViewController.h
//  EqBeats
//
//  Created by Tyrone Trevorrow on 2/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EBModel.h"
#import "EBAudioController.h"
#import "EBResourcesController.h"
#import "EBTrackCell.h"
#import "EBTrackListOperationsCell.h"
#import "EBPlaylist.h"

@interface EBTracksViewController : UITableViewController
@property (nonatomic, strong) UINib *trackCellNib;
@property (nonatomic, strong) NSMutableIndexSet *pickedIndexes;
@property (nonatomic, strong) NSArray *tracksToAdd;
@property (nonatomic, strong) EBPlaylist *playlist;
@property (nonatomic, strong) UIBarButtonItem *doneButtonItem;
@property (nonatomic, strong) EBTrackListOperationsCell *trackListOperationsCell;

- (void) setNeedsReload;
- (void) reloadData;

- (EBTrack*) trackForIndexPath: (NSIndexPath*) indexPath;
- (NSArray*) tracksForQueueAtIndexPath: (NSIndexPath*) indexPath;
- (NSArray*) allTracks;
- (EBTrackCell*) trackCellForIndexPath: (NSIndexPath*) indexPath;

- (void) doneButtonAction: (id) sender;
- (IBAction) addToPlaylistButtonAction: (id) sender;
- (IBAction) shufflePlayButtonAction: (id) sender;

@end
