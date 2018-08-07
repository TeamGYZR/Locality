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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setItinerary:(Itinerary *)itinerary{
    _itinerary = itinerary;
    self.pathTitle.text = itinerary.name;
    self.pathDescription.text = itinerary.pathDescription;
    [self.pathDescription sizeToFit];
    [self.pathTitle sizeToFit];
    if ([itinerary.category isEqualToString:@"Entertainment"]) {
        self.categoryImageView.image = [UIImage imageNamed:@"entertainmentIcon"];
    } else if ([itinerary.category isEqualToString:@"Nature"]){
        self.categoryImageView.image = [UIImage imageNamed:@"leafIcon"];
    } else {
        self.categoryImageView.image = [UIImage imageNamed:@"foodIcon"];
    }
}

@end
