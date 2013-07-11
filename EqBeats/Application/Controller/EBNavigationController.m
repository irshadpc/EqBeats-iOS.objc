//
//  EBNavigationController.m
//  EqBeats
//
//  Created by Tyrone Trevorrow on 2/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import "EBNavigationController.h"
#import "EBResourcesController.h"

@interface EBNavigationController ()

@end

@implementation EBNavigationController

- (void) viewDidLoad
{
    [super viewDidLoad];
    if (EBDeviceSystemMajorVersion() < 7) {
        [self.navigationBar setBackgroundImage: [UIImage imageNamed: @"NavigationBarBackground.png"]
                                 forBarMetrics: UIBarMetricsDefault];
    } else {
        [self.navigationBar setBarTintColor: @"#8239AB".color];
    }
}

@end
