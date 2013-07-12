//
//  EBVerticalExpandingLabel.h
//  EqBeats
//
//  Created by Tyrone Trevorrow on 12/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import "SDNibLoadedLabel.h"
#import "UIViewDesiredHeight.h"

@interface EBVerticalExpandingLabel : SDNibLoadedLabel <UIViewDesiredHeight>
@property (nonatomic, assign) CGFloat maximumHeight;
@end
