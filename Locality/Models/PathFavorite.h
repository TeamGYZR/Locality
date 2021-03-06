//
//  PathFavorite.h
//  Locality
//
//  Created by Ginger Dudley on 8/6/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "PFObject.h"
#import "User.h"
#import "Itinerary.h"
#import "Parse.h"

@interface PathFavorite : PFObject <PFSubclassing>

@property(strong, nonatomic) User *user;
@property (strong, nonatomic) Itinerary *itinerary;

+ (void)saveFavoritedPath:(Itinerary *_Nullable)itinerary withCompletion:(PFBooleanResultBlock _Nullable)completion;

+(void)removeFavoritedPath:(Itinerary * _Nullable)itinerary withCompletion:(PFBooleanResultBlock _Nullable)completion;

@end
