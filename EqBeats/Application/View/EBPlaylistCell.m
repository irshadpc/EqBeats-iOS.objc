//
//  EBPlaylistCell.m
//  EqBeats
//
//  Created by Tyrone Trevorrow on 20/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import "EBPlaylistCell.h"

@implementation EBPlaylistCell

- (void) setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing: editing animated: animated];
    if (editing) {
        self.contextButton.alpha = 0;
    } else {
        self.contextButton.alpha = 1;
    }
}

@end
