//
//  PathCell.h
//  Locality
//
//  Created by Zelalem Tenaw Terefe on 7/31/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Itinerary.h"
#import "User.h"
#import <MapKit/MapKit.h>
#import <ParseUI/ParseUI.h>

@interface PathCell : UITableViewCell
@property (strong, nonatomic) Itinerary * itinerary;
@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;

@property (weak, nonatomic) IBOutlet UILabel *profileNameField;
@property (weak, nonatomic) IBOutlet MKMapView *pathMapView;
@property (strong,nonatomic) User * user;
@end
