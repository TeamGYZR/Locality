//
//  LCMapView.h
//  Locality
//
//  Created by Youngmin Shin on 7/30/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import "Itinerary.h"
#import "User.h"

@interface LCMapView : UIView
- (void)configureWithItinerary:(Itinerary *)itinerary isStatic:(BOOL)move showCurrentLocation:(BOOL)showCurrent;
- (void)configureWithFavoritedPaths:(NSArray *)favoritedPaths;
- (void)directionsWithItinerary:(Itinerary *)itinerary;
@end
