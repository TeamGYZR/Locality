//
//  PathFavorite.m
//  Locality
//
//  Created by Ginger Dudley on 8/6/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "PathFavorite.h"

@implementation PathFavorite

@dynamic user;
@dynamic itinerary;

+ (nonnull NSString *)parseClassName {
    return @"PathFavorite";
}

+ (void)saveFavoritedPath:(Itinerary *)itinerary withCompletion:(PFBooleanResultBlock)completion{
    PathFavorite *newFavorite = [PathFavorite new];
    newFavorite.user = [User currentUser];
    newFavorite.itinerary = itinerary;
    [newFavorite saveInBackgroundWithBlock:completion];
}

+ (void)removeFavoritedPath:(Itinerary *)itinerary withCompletion:(PFBooleanResultBlock)completion{
    PFQuery *query = [PFQuery queryWithClassName:@"PathFavorite"];
    [query whereKey:@"user" equalTo: PFUser.currentUser];
    [query whereKey:@"itinerary" equalTo:itinerary];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error unfavoriting path");
        } else if (object){
            [object deleteInBackgroundWithBlock:completion];
        }
    }];
    
}

@end
