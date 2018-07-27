//
//  UserCell.m
//  Locality
//
//  Created by Ginger Dudley on 7/25/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "UserCell.h"

@implementation UserCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setUser:(User *)user{
    _user = user;
    self.userName.text = user.name;
    [self.userName sizeToFit];
    self.userUsername.text = user.username;
    [self.userUsername sizeToFit];
    self.userProfilePicture.file = user.profilePicture;
    [self.userProfilePicture loadInBackground];
}

@end
