//
//  CLLocationManagerSingleton.h
//  Locality
//
//  Created by Youngmin Shin on 8/7/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CLLocationManagerSingleton : NSObject

@property (strong, nonatomic) CLLocationManager *locationManager;

+(CLLocationManagerSingleton*)sharedSingleton; 

@end
