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

@protocol LCMapViewDelegate
-(id)mapViewType;
@end

@interface LCMapView : UIView
@property (strong, nonatomic) Itinerary *itinerary;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) MKPolyline *polyline;
@property (strong, nonatomic) id<LCMapViewDelegate> delegate;
- (void)initWithMap;
@end
