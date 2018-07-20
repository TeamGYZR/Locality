//
//  Favorite.h
//  Locality
//
//  Created by Youngmin Shin on 7/19/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"
#import "User.h"
#import "Venue.h"

@interface Favorite : PFObject <PFSubclassing>

@property (nonatomic, strong) PFUser * user;
@property (nonatomic, strong) NSString * venueID;

+ (void) saveFavoritedVenue: (Venue * _Nullable)venue withCompletion: (PFBooleanResultBlock  _Nullable)completion;

+ (void) removeVenue: (Venue * _Nullable)venue withCompletion: (PFBooleanResultBlock  _Nullable)completion;


@end
