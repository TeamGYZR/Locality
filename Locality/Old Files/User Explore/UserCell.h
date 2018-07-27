//
//  UserCell.h
//  Locality
//
//  Created by Ginger Dudley on 7/25/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse.h"
#import "ParseUI/ParseUI.h"
#import "User.h"

@interface UserCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *userProfilePicture;
@property (weak, nonatomic) IBOutlet UILabel *userUsername;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) User *user;

@end
