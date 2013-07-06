//
//  EBModel.m
//  EqBeats
//
//  Created by Tyrone Trevorrow on 6/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import "EBModel.h"

@implementation EBModel

+ (EBModel*) sharedModel
{
    __strong static EBModel *sharedModel = nil;
    if (sharedModel == nil) {
        sharedModel = [EBModel new];
    }
    return sharedModel;
}

@end
