//
//  EBPlaylistCell.h
//  EqBeats
//
//  Created by Tyrone Trevorrow on 20/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EBPlaylistCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *tracksLabel;
@property (strong, nonatomic) IBOutlet UIButton *contextButton;

@end
