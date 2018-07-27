//
//  Follow.m
//  Locality
//
//  Created by Ginger Dudley on 7/26/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "Follow.h"

@implementation Follow

@dynamic follower;
@dynamic followee;

+ (nonnull NSString *)parseClassName {
    return @"Follow";
}

+ (void)saveFollow:(User *)follower withFollowee:(User *)followee withCompletion:(PFBooleanResultBlock)completion{
    Follow *newFollow = [Follow new];
    newFollow.follower = follower;
    newFollow.followee = followee;
    [newFollow saveInBackgroundWithBlock:completion];
}

@end
