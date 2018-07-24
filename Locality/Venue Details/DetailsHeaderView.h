//
//  DetailsHeaderView.h
//  Locality
//
//  Created by Ginger Dudley on 7/24/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Venue.h"
#import "Favorite.h"
#import "ReviewViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface DetailsHeaderView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIImageView *venueImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

-(void)setAFilledStar;
-(void)setAnEmptyStar;

@end
