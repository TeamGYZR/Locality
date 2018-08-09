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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)setItinerary:(Itinerary *)itinerary{
    _itinerary = itinerary;
    self.pathNameField.text = itinerary.name;
    self.pathDescriptionField.text = itinerary.pathDescription;
    self.profileNameField.text = itinerary.creator.name;
    self.profileImageView.file = self.itinerary.creator.profilePicture;
    [self.profileImageView loadInBackground];
    PFFile *holderFile = self.itinerary.mapImageFile;
    [holderFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!data) {
            return NSLog(@"%@", error);
        }
        self.mapViewImage.image = [UIImage imageWithData:data];
    }];
    NSString *pinNames = @"Pins include: ";
    for(int i = 0; i < [itinerary.pinnedLocations count]; i++){
        if(itinerary.pinnedLocations[i][@"name"]){
        pinNames = [pinNames stringByAppendingString:[itinerary.pinnedLocations[i][@"name"] stringByAppendingString:@", "]] ;
        }
    }
    float distanceInMiles = ([itinerary.distanceFromFirstPinnedLocation doubleValue]  * .00062137);
    NSString *distanceString = [NSString stringWithFormat:@"%.02f", distanceInMiles];
    self.distanceLabel.text = [[@"Distance to first pin: " stringByAppendingString:distanceString] stringByAppendingString:@" miles"];
    NSUInteger fixedLength = [pinNames length] - 2;
    NSString *fixedPinNames = [pinNames substringToIndex:fixedLength];
    self.pinNames.text = fixedPinNames;
    //[self.layer setCornerRadius:30.0f];
    [self.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.layer setShadowOpacity:0.8];
    [self.layer setShadowRadius:3.0];
    [self.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
}


@end
