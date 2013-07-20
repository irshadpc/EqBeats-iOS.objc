//
//  EBPlaylistViewController.h
//  EqBeats
//
//  Created by Tyrone Trevorrow on 2/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import "EBTracksViewController.h"
#import "EBPlaylist.h"
#import "EBTrack.h"

@interface EBPlaylistViewController : EBTracksViewController
@property (nonatomic, strong) EBPlaylist *playlist;

@end
