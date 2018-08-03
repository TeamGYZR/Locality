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
- (void)setItinerary:(Itinerary *)itinerary{
    _itinerary = itinerary;
    self.pathNameField.text = itinerary.name;
    self.pathDescriptionField.text = itinerary.pathDescription;
    self.profileNameField.text = itinerary.creator.name;
    self.profileImageView.file = self.itinerary.creator.profilePicture;
    [self.profileImageView loadInBackground];
    [self.lcMapView configureWithItinerary:itinerary isStatic:YES];
}


@end
