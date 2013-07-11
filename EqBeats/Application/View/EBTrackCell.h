//
//  EBTrackCell.h
//  EqBeats
//
//  Created by Tyrone Trevorrow on 2/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import "SDNibLoadedTableViewCell.h"

@interface EBTrackCell : SDNibLoadedTableViewCell
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *detailTitleLabel;
@property (nonatomic, strong) IBOutlet UIImageView *artworkView;
@end
