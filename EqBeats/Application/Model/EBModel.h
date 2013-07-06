//
//  EBModel.h
//  EqBeats
//
//  Created by Tyrone Trevorrow on 6/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EBAudioController;
@interface EBModel : NSObject
@property (nonatomic, strong) EBAudioController *audioController;

+ (EBModel*) sharedModel;

@end
