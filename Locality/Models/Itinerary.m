//
//  Itinerary.m
//  Locality
//
//  Created by Ginger Dudley on 7/27/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "Itinerary.h"

@implementation Itinerary

@dynamic name;
@dynamic creator;
@dynamic pathDescription;
@dynamic category;
@dynamic pinnedLocations;
@dynamic paths;
@dynamic distanceFromFirstPinnedLocation;

+ (nonnull NSString *)parseClassName {
    return @"Itinerary";
}

@end
