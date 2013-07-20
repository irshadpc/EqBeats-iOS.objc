//
//  EBPlaylistsViewController.h
//  EqBeats
//
//  Created by Tyrone Trevorrow on 2/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EBShadowedTextField;

@interface EBPlaylistsViewController : UITableViewController
@property (nonatomic, copy) NSArray *tracksToAdd;
@property (nonatomic, strong) EBShadowedTextField *titleTextField;

@end
