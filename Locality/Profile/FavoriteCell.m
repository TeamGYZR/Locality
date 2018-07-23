//
//  FavoriteCell.m
//  Locality
//
//  Created by Ginger Dudley on 7/19/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "FavoriteCell.h"
#import "APImanager.h"
#import "Favorite.h"


@implementation FavoriteCell

//set-up to do with profile cell: have button to show favorites depending on how the favorites is connected to the user

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didTapFavorite:(id)sender {
    
    [Favorite removeVenue:(Venue * _Nullable)self.venue withCompletion:^(BOOL worked, NSError * _Nullable __strong error){
        if(error)
        {
            NSLog(@"favorite deletion did not work :( - %@", error.localizedDescription);
        }
        else{
            //do something by changing the value for the users propoerty for favorites
            [self.delegate loadFavorites];

            NSLog(@"favorite successfully deleted :D");
        }
    }];
    
}

- (void)setVenue:(Venue *)venue
{
    _venue = venue;
    self.venueName.text = venue.name;
    self.venueAddress.text = venue.streetAddress; 
}

@end
