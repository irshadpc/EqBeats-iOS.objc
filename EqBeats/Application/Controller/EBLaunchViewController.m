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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self.navigationController setNavigationBarHidden: YES animated: animated];
    [self.launchView reloadData];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear: animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage*) imageForLaunchBackgroundView:(EBLaunchBackgroundView *)view
{
    _imageCount = (_imageCount + 1) % 35;
    return [UIImage imageNamed: [NSString stringWithFormat: @"albumart/%i.jpg", _imageCount]];
}

@end
