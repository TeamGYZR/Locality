//
//  CommentCell.h
//  Locality
//
//  Created by Ginger Dudley on 7/23/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Venue.h"
#import "Comment.h"

@interface CommentCell : UITableViewCell

@property (strong, nonatomic) Comment *comment;
@property (weak, nonatomic) IBOutlet UIImageView *userProfilePicture;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userComment;

@end
