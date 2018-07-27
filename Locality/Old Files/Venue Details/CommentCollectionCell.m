//
//  CommentCollectionCell.m
//  Locality
//
//  Created by Ginger Dudley on 7/24/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "CommentCollectionCell.h"


@implementation CommentCollectionCell

-(void)setComment:(Comment *)comment{
    _comment = comment;
    self.userComment.text = comment.commentText;
    self.userName.text = comment.user.name;
    self.userProfilePicture.file = comment.user.profilePicture;
    [self.userProfilePicture loadInBackground];
    
}

@end
