//
//  User.h
//  Locality
//
//  Created by Ginger Dudley on 7/19/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "PFUser.h"
#import "Parse/Parse.h"

@interface User : PFUser <PFSubclassing>

@property (strong, nonatomic) NSString *name;
//might need to make this into a pffile 
@property PFFile *profilePicture;

@end
