//
//  PathDetailsViewController.h
//  Locality
//
//  Created by Youngmin Shin on 7/27/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "User.h"
#import "Itinerary.h"
#import "ParseUI/ParseUI.h"
#import "Path.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "LCMapView.h"

@interface PathDetailsViewController : UIViewController
@property (strong, nonatomic) Itinerary * itinerary; 
@end
