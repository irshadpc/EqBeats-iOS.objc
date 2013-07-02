//
//  EBModelObject.h
//  EqBeats
//
//  Created by Tyrone Trevorrow on 2/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EBModelObject : NSManagedObject

@property (nonatomic) int32_t uid;
@property (nonatomic, retain) NSString * detail;
@property (nonatomic, retain) NSString * htmlDescription;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * plainDetail;

@end
