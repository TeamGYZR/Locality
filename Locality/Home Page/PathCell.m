//
//  PathCell.m
//  Locality
//
//  Created by Zelalem Tenaw Terefe on 7/31/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "PathCell.h"


@implementation PathCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (PFImageView *)profileImageView{
    _profileImageView.file=self.user.profilePicture;
    [_profileImageView loadInBackground];
    return _profileImageView;
}
- (UILabel *)profileNameField{
    _profileNameField.text=self.itinerary.name;
    return _profileNameField;
}

@end
