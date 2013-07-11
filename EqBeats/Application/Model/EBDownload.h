//
//  EBDownload.h
//  EqBeats
//
//  Created by Tyrone Trevorrow on 6/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "EBMappableObject.h"

@interface EBDownload : EBMappableObject

@property (nonatomic, retain) NSString * art;
@property (nonatomic, retain) NSString * opus;
@property (nonatomic, retain) NSString * vorbis;
@property (nonatomic, retain) NSString * aac;
@property (nonatomic, retain) NSString * mp3;
@property (nonatomic, retain) NSString * original;

@end
