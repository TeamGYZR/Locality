//
//  Initnerary.h
//  Locality
//
//  Created by Ginger Dudley on 7/27/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "PFObject.h"
#import "Parse.h"
#import "User.h"
#import "Path.h"
#import <CoreLocation/CoreLocation.h>

@interface Initnerary : PFObject <PFSubclassing>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) User *creator;
@property (strong, nonatomic) NSString *pathDescription;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSMutableArray *pinnedLocations;
@property (strong, nonatomic) Path *path;
@property (strong, nonatomic) NSNumber *distanceFromFirstPinnedLocation;

@end
