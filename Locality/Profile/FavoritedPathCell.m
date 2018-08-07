//
//  FavoritedPathCell.m
//  Locality
//
//  Created by Ginger Dudley on 8/7/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "FavoritedPathCell.h"

@implementation FavoritedPathCell

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
    self.pathTitle.text = itinerary.name;
    self.pathDescription.text = itinerary.pathDescription;
    [self.pathDescription sizeToFit];
    [self.pathTitle sizeToFit];
}

@end
