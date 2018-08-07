//
//  FavoritedPathCell.h
//  Locality
//
//  Created by Ginger Dudley on 8/7/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Itinerary.h"

@interface FavoritedPathCell : UITableViewCell

@property (strong, nonatomic) Itinerary *itinerary;
@property (weak, nonatomic) IBOutlet UILabel *pathTitle;
@property (weak, nonatomic) IBOutlet UILabel *pathDescription;

@end
