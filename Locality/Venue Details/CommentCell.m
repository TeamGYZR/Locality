//
//  CommentCell.m
//  Locality
//
//  Created by Ginger Dudley on 7/23/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "CommentCell.h"
#import "APImanager.h"
#import "Parse.h"

@implementation CommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setComment:(Comment *)comment{
    _comment = comment;
    self.userComment.text = comment.commentText;
    self.userName.text = comment.user.name;
    self.userProfilePicture.file = comment.user.profilePicture;
    [self.userProfilePicture loadInBackground];
    
}

@end
