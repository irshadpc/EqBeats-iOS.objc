//
//  EBUserCell.h
//  EqBeats
//
//  Created by Tyrone Trevorrow on 2/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import "SDNibLoadedTableViewCell.h"
@class SDAnchorView, EBImageView;

@interface EBUserCell : SDNibLoadedTableViewCell
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, strong) IBOutlet EBImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet SDAnchorView *layoutView;

@end
