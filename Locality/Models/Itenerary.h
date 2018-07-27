//
//  Itenerary.h
//  Locality
//
//  Created by Ginger Dudley on 7/27/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "PFObject.h"
#import "Parse.h"
#import "User.h"
#import "Path.h"

@interface Itenerary : PFObject <PFSubclassing>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) User *creator;
@property (strong, nonatomic) NSString *pathDescription;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSArray *pinnedLocations;
@property (strong, nonatomic) Path *path;


@end