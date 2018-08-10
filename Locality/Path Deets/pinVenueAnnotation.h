//
//  pinVenueAnnotation.h
//  Locality
//
//  Created by Ginger Dudley on 8/2/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "ItineraryPin.h"
#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>

@interface pinVenueAnnotation : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;
@property (strong, nonatomic) PFFile *picture;
@property (nonatomic, strong) NSString *pinDescription;
@property (nonatomic, strong) NSString *pinCategory;
- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
