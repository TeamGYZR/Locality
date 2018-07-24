//
//  CommentCell.m
//  Locality
//
//  Created by Ginger Dudley on 7/23/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "CommentCell.h"
#import "APImanager.h"

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
}

@end
