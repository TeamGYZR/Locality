//
//  Comment.m
//  Locality
//
//  Created by Ginger Dudley on 7/23/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "Comment.h"

@implementation Comment

@dynamic user;
@dynamic latitude;
@dynamic longitude;
@dynamic venueName;
@dynamic commentText;

+ (nonnull NSString *)parseClassName {
    return @"Comment";
}

+(void)saveVenueComment:(Venue *)venue withComment:(NSString *)comment withCompletion:(PFBooleanResultBlock)completion{
    Comment *newComment = [Comment new];
    newComment.user = User.currentUser;
    newComment.venueName = venue.name;
    newComment.latitude = venue.latitude;
    newComment.longitude = venue.longitude;
    newComment.commentText = comment;
    [newComment saveInBackgroundWithBlock:completion];
}



@end
