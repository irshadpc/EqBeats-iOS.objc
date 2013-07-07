//
//  EBLaunchViewController.m
//  EqBeats
//
//  Created by Tyrone Trevorrow on 2/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import "EBLaunchViewController.h"
#import "EBLaunchBackgroundView.h"

@interface EBLaunchViewController () <EBLaunchBackgroundViewDataSource>

@end

@implementation EBLaunchViewController {
    NSInteger _imageCount;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self.navigationController setNavigationBarHidden: YES animated: animated];
    [self.launchView reloadData];
}

- (UIImage*) imageForLaunchBackgroundView:(EBLaunchBackgroundView *)view
{
    _imageCount = (_imageCount + 1) % 35;
    return [UIImage imageNamed: [NSString stringWithFormat: @"albumart/%i.jpg", _imageCount]];
}

- (IBAction)tapAction:(id)sender
{
    [self performSegueWithIdentifier: @"PushToTabBarController" sender: self];
}

@end
