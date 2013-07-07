//
//  EBNavigationController.m
//  EqBeats
//
//  Created by Tyrone Trevorrow on 2/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import "EBNavigationController.h"

@interface EBNavigationController ()

@end

@implementation EBNavigationController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.navigationBar setBackgroundImage: [UIImage imageNamed: @"NavigationBarBackground.png"]
                             forBarMetrics: UIBarMetricsDefault];
}

@end
