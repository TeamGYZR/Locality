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
@property PFFile *profilePicture;
//@property (strong, nonatomic) NSMutableArray *followers;
//@property (strong, nonatomic) NSMutableArray *following;

@end
