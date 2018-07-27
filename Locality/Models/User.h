//
//  User.h
//  Locality
//
//  Created by Ginger Dudley on 7/27/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "PFObject.h"
#import "Parse.h"

@interface User : PFObject <PFSubclassing>

@property (strong, nonatomic) NSString *name;
@property PFFile *profilePicture;

@end
