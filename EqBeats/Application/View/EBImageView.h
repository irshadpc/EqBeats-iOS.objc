//
//  EBImageView.h
//  EqBeats
//
//  Created by Tyrone Trevorrow on 2/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "UIViewDesiredHeight.h"
#import "UIViewDesiredWidth.h"

@interface EBImageView : UIImageView <UIViewDesiredHeight, UIViewDesiredWidth>

@end
