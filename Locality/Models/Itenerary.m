//
//  Itenerary.m
//  Locality
//
//  Created by Ginger Dudley on 7/27/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "Itenerary.h"

@implementation Itenerary

@dynamic name;
@dynamic creator;
@dynamic pathDescription;
@dynamic category;
@dynamic pinnedLocations;
@dynamic path;
@dynamic distanceFromFirstPinnedLocation;

+ (nonnull NSString *)parseClassName {
    return @"Itenerary";
}

@end
