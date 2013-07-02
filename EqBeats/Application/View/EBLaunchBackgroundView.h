//
//  EBLaunchBackgroundView.h
//  EqBeats
//
//  Created by Tyrone Trevorrow on 1/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EBLaunchBackgroundView;
@protocol EBLaunchBackgroundViewDataSource <NSObject>

- (UIImage*) imageForLaunchBackgroundView: (EBLaunchBackgroundView*) view;

@end

@interface EBLaunchBackgroundView : UIView
@property (nonatomic, weak) IBOutlet id<EBLaunchBackgroundViewDataSource> dataSource;

- (void) reloadData;

@end
