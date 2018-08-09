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

@interface pinVenueAnnotation : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;
- (id)initWithDictionary:(NSDictionary *)dictionary;
- (id)initWithItineraryPin:(Itinerary *)itineraryPin;
//- (MKAnnotationView *)annotationView;

@end
