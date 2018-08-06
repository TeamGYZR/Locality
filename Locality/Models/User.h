//
//  User.h
//  Locality
//
//  Created by Zelalem Tenaw Terefe on 7/27/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "PFUser.h"
#import "Parse/Parse.h"

@interface User : PFUser <PFSubclassing>

@property (strong, nonatomic) NSString *name;
@property PFFile *profilePicture;
@property (strong, nonatomic) NSMutableArray *favoritedPaths;

@end
