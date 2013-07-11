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

@interface EBTracksViewController : UITableViewController
@property (nonatomic, strong) UINib *trackCellNib;

- (EBTrack*) trackForIndexPath: (NSIndexPath*) indexPath;
- (NSArray*) tracksForQueueAtIndexPath: (NSIndexPath*) indexPath;
- (EBTrackCell*) trackCellForIndexPath: (NSIndexPath*) indexPath;


@end
