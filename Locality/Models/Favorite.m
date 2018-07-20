//
//  Favorite.m
//  Locality
//
//  Created by Youngmin Shin on 7/19/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//


#import "Favorite.h"

@implementation Favorite

@dynamic venueID;
@dynamic user;

+ (nonnull NSString *)parseClassName {
    return @"Favorite";
}

+ (void) saveFavoritedVenue: (Venue * _Nullable)venue withCompletion: (PFBooleanResultBlock  _Nullable)completion{
    
    Favorite *newFavorite = [Favorite new];
    newFavorite.user = PFUser.currentUser;
    newFavorite.venueID = venue.idStr;
    
    [newFavorite saveInBackgroundWithBlock:completion];
    
    
}

+ (void) removeVenue: (Venue * _Nullable)venue withCompletion: (PFBooleanResultBlock  _Nullable)completion{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Favorite"];
    [query whereKey:@"user" equalTo: PFUser.currentUser];
    [query whereKey:@"venueID" equalTo: venue.idStr];
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *favorite, NSError *error) {
        if (favorite != nil) {
            // do something with the array of object returned by the call
            [favorite[0] deleteInBackgroundWithBlock:completion];
        } else {
            NSLog(@"Could not delete favorite - %@", error.localizedDescription);
        }
    }];
    
    
    
}


@end
