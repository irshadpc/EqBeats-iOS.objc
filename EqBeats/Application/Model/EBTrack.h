//
//  EBTrack.h
//  EqBeats
//
//  Created by Tyrone Trevorrow on 2/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "EBModelObject.h"

@class EBUser;

@interface EBTrack : EBModelObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * download;
@property (nonatomic, retain) EBUser *artist;

@end
