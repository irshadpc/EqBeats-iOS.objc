//
//  EBAPI.m
//  EqBeats
//
//  Created by Tyrone Trevorrow on 2/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import "EBAPI.h"
#import "AFNetworking.h"
#import "EBModel.h"
#import "EBModelObject.h"
#import "EBUser.h"
#import "EBTrack.h"

NSString * const EBAPIBaseURL = @"https://eqbeats.org";

@implementation EBAPI

+ (void) getUserWithSearchQuery: (NSString*) query completion: (void (^)(NSArray *objects, NSError *error)) completion
{
    if ([query length] > 0) {
        query = [query stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        NSURL *baseURL = [NSURL URLWithString: EBAPIBaseURL];
        NSString *urlString = [NSString stringWithFormat: @"/users/search/json?q=%@", query];
        NSURL *url = [NSURL URLWithString: urlString relativeToURL: baseURL];
        [self getObjectsFromURL: url objectClass: [EBUser class] completion: completion];
    }
}

+ (void) getLatestTracksCompletion: (void (^)(NSArray *objects, NSError *error)) completion
{
    NSURL *baseURL = [NSURL URLWithString: EBAPIBaseURL];
    NSString *urlString = @"/tracks/latest/json";
    NSURL *url = [NSURL URLWithString: urlString relativeToURL: baseURL];
    [self getObjectsFromURL: url objectClass: [EBTrack class] completion: completion];
}

+ (void) getFeaturedTracksCompletion: (void (^)(NSArray *objects, NSError *error)) completion
{
    NSURL *baseURL = [NSURL URLWithString: EBAPIBaseURL];
    NSString *urlString = @"/tracks/featured/json";
    NSURL *url = [NSURL URLWithString: urlString relativeToURL: baseURL];
    [self getObjectsFromURL: url objectClass: [EBTrack class] completion: completion];
}

+ (void) getRandomTracksCompletion: (void (^)(NSArray *objects, NSError *error)) completion
{
    NSURL *baseURL = [NSURL URLWithString: EBAPIBaseURL];
    NSString *urlString = @"/tracks/random/json";
    NSURL *url = [NSURL URLWithString: urlString relativeToURL: baseURL];
    [self getObjectsFromURL: url objectClass: [EBTrack class] completion: completion];
}

+ (void) getTracksWithSearchQuery: (NSString*) query completion: (void (^)(NSArray *objects, NSError *error)) completion
{
    if ([query length] > 0) {
        query = [query stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        NSURL *baseURL = [NSURL URLWithString: EBAPIBaseURL];
        NSString *urlString = [NSString stringWithFormat: @"/tracks/search/json?q=%@", query];
        NSURL *url = [NSURL URLWithString: urlString relativeToURL: baseURL];
        [self getObjectsFromURL: url objectClass: [EBTrack class] completion: completion];
    }
}

+ (void) getObjectsFromURL: (NSURL*) url objectClass: (Class) objectClass completion: (void (^)(NSArray *objects, NSError *error)) completion
{
    NSURLRequest *request = [NSURLRequest requestWithURL: url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest: request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSArray *objects = [self mappedObjectsFromJSON: JSON objectClass: objectClass];
        if (objects && completion != NULL) {
            completion(objects, nil);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (completion != NULL) {
            completion(nil, error);
        }
    }];
    [operation start];
}

+ (NSArray*) mappedObjectsFromJSON: (id) JSON objectClass: (Class) objectClass
{
    NSMutableArray *objects = nil;
    if ([JSON isKindOfClass: [NSArray class]]) {
        NSArray *array = JSON;
        objects = [NSMutableArray arrayWithCapacity: array.count];
        for (id jsonValue in array) {
            if ([jsonValue isKindOfClass: [NSDictionary class]]) {
                EBModelObject *entity = [objectClass objectFromMappableData: jsonValue inContext: [EBModel sharedModel].mainThreadObjectContext];
                [objects addObject: entity];
            }
        }
        return objects.copy;
    } else if ([JSON isKindOfClass: [NSDictionary class]]) {
        EBModelObject *entity = [objectClass objectFromMappableData: JSON inContext: [EBModel sharedModel].mainThreadObjectContext];
        if (entity) {
            return @[entity];
        } else {
            return @[];
        }
    } else {
        return @[];
    }
}

@end
