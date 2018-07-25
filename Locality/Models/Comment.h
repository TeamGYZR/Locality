//
//  Comment.h
//  Locality
//
//  Created by Ginger Dudley on 7/23/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "PFObject.h"
#import "Parse.h"
#import "User.h"
#import "Venue.h"

@interface Comment : PFObject <PFSubclassing>

//maybe make this a user?
//@property (strong, nonatomic) PFUser *user;
@property(strong, nonatomic) User *user;
@property (nonatomic, strong) NSString *venueName;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSString *commentText;

//venue_id
//venue_blob

+(void) saveVenueComment: (Venue * _Nullable)venue withComment: ( NSString * _Nullable )comment withCompletion:(PFBooleanResultBlock  _Nullable)completion;


@end
