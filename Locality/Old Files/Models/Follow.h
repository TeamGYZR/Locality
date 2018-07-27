//
//  Follow.h
//  Locality
//
//  Created by Ginger Dudley on 7/26/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "PFObject.h"
#import "User.h"

@interface Follow : PFObject <PFSubclassing>

@property User *follower;
@property User *followee;

+ (void)saveFollow: (User * _Nullable)follower withFollowee: (User * _Nullable)followee withCompletion:(PFBooleanResultBlock  _Nullable)completion;

@end
