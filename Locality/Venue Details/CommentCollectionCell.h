//
//  CommentCollectionCell.h
//  Locality
//
//  Created by Ginger Dudley on 7/24/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"
#import "ParseUI/ParseUI.h"
#import "Parse.h"

@interface CommentCollectionCell : UICollectionViewCell

@property (strong, nonatomic) Comment *comment;
@property (weak, nonatomic) IBOutlet PFImageView *userProfilePicture;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userComment;


@end
