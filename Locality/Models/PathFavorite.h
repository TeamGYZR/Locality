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

@interface PathFavorite : PFObject

@property(strong, nonatomic) User *user;
@property (strong, nonatomic) Itinerary *itinerary;

@end
