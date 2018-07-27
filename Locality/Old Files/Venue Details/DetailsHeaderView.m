//
//  DetailsHeaderView.m
//  Locality
//
//  Created by Ginger Dudley on 7/24/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "DetailsHeaderView.h"
#import "DetailsViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "UIImageView+AFNetworking.h"
#import "DetailsCollectionViewController.h"
#import "Parse.h"

@implementation DetailsHeaderView

-(void)setAFilledStar{
    UIImage *favoriteButtonImage = [UIImage imageNamed:@"star"];
    [self.favoriteButton setImage:favoriteButtonImage forState:UIControlStateNormal];
}
-(void)setAnEmptyStar{
    UIImage *unfavoriteButtonImage = [UIImage imageNamed:@"emptyStar"];
    [self.favoriteButton setImage:unfavoriteButtonImage forState:UIControlStateNormal];
}


@end
