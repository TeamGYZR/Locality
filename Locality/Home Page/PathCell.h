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
#import "LCMapView.h"

@interface PathCell : UITableViewCell
@property (strong, nonatomic) Itinerary * itinerary;
@property (strong, nonatomic) NSString * list;
@property (strong, nonatomic) NSDictionary * lists;
@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *profileNameField;
@property (weak, nonatomic) IBOutlet UILabel *pathNameField;
@property (weak, nonatomic) IBOutlet UILabel *pathDescriptionField;
@property (weak, nonatomic) IBOutlet LCMapView *lcMapView;
@property (weak, nonatomic) IBOutlet PFImageView *mapViewImage;
@property (weak, nonatomic) IBOutlet UILabel *pinNames;
@property (weak, nonatomic) IBOutlet UIView *cellView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@end
