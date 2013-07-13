//
//  SDAppDelegate.h
//  EqBeats
//
//  Created by Tyrone Trevorrow on 1-07-13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EBWindow.h"

@interface EBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) EBWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;

+ (EBAppDelegate*) appDelegate;

@end
