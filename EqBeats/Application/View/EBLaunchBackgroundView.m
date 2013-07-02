//
//  EBLaunchBackgroundView.m
//  EqBeats
//
//  Created by Tyrone Trevorrow on 1/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import "EBLaunchBackgroundView.h"
#import "EBImageView.h"
#import "SDHorizontalLayoutView.h"
#import "SDVerticalLayoutView.h"
#import <QuartzCore/QuartzCore.h>

@interface EBLaunchBackgroundView ()
@property (nonatomic, strong) SDHorizontalLayoutView *layoutView;
@property (nonatomic, strong) NSMutableArray *columns;
@end

static const CGSize kCellSize = {90,90};
static const NSInteger kOffscreenCols = 1;
static const NSInteger kOffscreenRows = 1;
static const CGFloat kAnimationOffset = 90.0f;

@implementation EBLaunchBackgroundView {
    BOOL _animating;
}

- (void) willMoveToWindow:(UIWindow *)newWindow
{
    if (newWindow == nil) {
        [self stopAnimating];
    }
}

- (void) reloadData
{
    if (self.columns == nil) {
        self.columns = [NSMutableArray new];
    }
    if (self.dataSource == nil) {
        return;
    }
    if (self.layoutView == nil) {
        self.layoutView = [[SDHorizontalLayoutView alloc] initWithFrame: self.bounds];
        self.layoutView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview: self.layoutView];
        CGRect f = self.layoutView.frame;
        f.origin.x = -24;
        f.origin.y = -40;
        self.layoutView.frame = f;
        [self addSubview: self.layoutView];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: @"transform"];
        CATransform3D t = CATransform3DIdentity;
        t.m34 = 1.0 / -500.0;
        t = CATransform3DRotate(t, -0.3, 0.0, 1.0, 0.0);
        self.layoutView.layer.transform = t;
        animation.duration = 3.0;
        animation.fromValue = [NSValue valueWithCATransform3D: CATransform3DIdentity];
        animation.toValue = [NSValue valueWithCATransform3D: t];
        [self.layoutView.layer addAnimation: animation forKey: @"rotateIn"];
    }
    
    NSInteger numCols = ceilf(self.frame.size.width / kCellSize.width) + kOffscreenCols;
    NSInteger numRows = ceilf(self.frame.size.height / kCellSize.height) + kOffscreenRows;
    NSInteger neededCols = numCols - self.columns.count;
    for (NSInteger i = 0; i < neededCols; i++) {
        SDVerticalLayoutView *view = [[SDVerticalLayoutView alloc] initWithFrame: CGRectMake(0, 0, kCellSize.width, self.frame.size.height)];
        for (NSInteger j = 0; j < numRows; j++) {
            EBImageView *cell = [[EBImageView alloc] initWithImage: [self.dataSource imageForLaunchBackgroundView: self]];
            cell.frame = CGRectMake(0, 0, kCellSize.width, kCellSize.height);
            cell.backgroundColor = [UIColor whiteColor];
            [view addSubview: cell];
        }
        [self.layoutView addSubview: view];
        [view layoutIfNeeded];
        [self.columns addObject: view];
    }
    [self.layoutView layoutIfNeeded];
    
    if (!_animating) {
        [self startAnimating];
    }
}

- (void) moveColumns
{
    if (self.columns == nil) {
        self.columns = [NSMutableArray new];
    }
    
    [UIView animateWithDuration: 3.5
                          delay: 0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         for (UIView *view in self.columns) {
                             CGRect f = view.frame;
                             f.origin.x -= kAnimationOffset;
                             view.frame = f;
                         }
                     } completion:^(BOOL finished) {
                         if (finished && _animating) {
                             [self rotateColumns];
                             [self moveColumns];
                         }
                     }];
}

- (void) rotateColumns
{
    if (self.columns.count == 0) {
        return;
    }
    
    NSInteger colCount = self.columns.count;
    for (NSInteger i = 0; i < kOffscreenCols; i++) {
        UIView *view = [self.columns firstObject];
        CGRect f = view.frame;
        f.origin.x += kCellSize.width * colCount;
        view.frame = f;
        [self.columns removeObjectAtIndex: 0];
        [self.columns addObject: view];
    }
}

- (void) startAnimating
{
    if (!_animating) {
        [self moveColumns];
        _animating = YES;
    }
}

- (void) stopAnimating
{
    _animating = NO;
}

@end
