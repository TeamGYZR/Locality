//
//  FavoriteCell.h
//  Locality
//
//  Created by Ginger Dudley on 7/19/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Venue.h"
#import "Favorite.h"

@protocol FavoriteCellDelegate

-(void)loadFavorites; 

@end


@interface FavoriteCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *venueName;
@property (weak, nonatomic) IBOutlet UILabel *venueAddress;
@property (strong, nonatomic) Venue *venue;
@property (nonatomic, weak) id<FavoriteCellDelegate> delegate;

@end
