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

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (IBAction)didTapFavorite:(id)sender {
    
    [Favorite removeVenue:(Venue * _Nullable)self.venue withCompletion:^(BOOL worked, NSError * _Nullable __strong error){
        if(error)
        {
            NSLog(@"favorite deletion did not work :( - %@", error.localizedDescription);
        }
        else{
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
