//
//  Itinerary.h
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

@interface Itinerary : PFObject <PFSubclassing>

@property (strong, nonatomic) NSString * _Nullable name;
@property (strong, nonatomic) User * _Nullable creator;
@property (strong, nonatomic) NSString * _Nullable pathDescription;
@property (strong, nonatomic) NSString * _Nullable category;
@property (strong, nonatomic) NSMutableArray * _Nullable pinnedLocations;
@property (strong, nonnull) NSArray *paths;
@property (strong, nonatomic) NSNumber * _Nullable distanceFromFirstPinnedLocation;
@property (strong, nonatomic) PFFile  * _Nullable mapImageFile;
@property (strong, nonatomic) NSMutableArray * _Nullable uniqueUserViews;

@end
