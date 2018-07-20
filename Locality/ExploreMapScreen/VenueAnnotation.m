//
//  VenueAnnotation.m
//  Locality
//
//  Created by Youngmin Shin on 7/17/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "VenueAnnotation.h"
#import <Mapkit/Mapkit.h>
#import <CoreLocation/CoreLocation.h>
#import "VenueAnnotationView.h"

@implementation VenueAnnotation

-(id)initWithName:(NSString *)name Coordinate:(CLLocationCoordinate2D )coordinate Address:(NSString *)address AndImageurl:(NSURL *)imageURL{
    
    self = [super init];
    
    if(self)
    {
        _title = name;
        _coordinate = coordinate;
        _subtitle = address;
        _imageURL = imageURL;
        _venue = nil;
        _category = nil;
    }
    
    return self; 
    
    
    
}

-(id)initWithVenue:(Venue *)venue{
    
    
    self = [super init];
    
    if(self)
    {
        _venue = venue; 
        _title = venue.name;
        _coordinate = CLLocationCoordinate2DMake(venue.latitude.doubleValue, venue.longitude.doubleValue);
        _subtitle = venue.streetAddress;
        _imageURL = venue.iconURL;
        _category = venue.category; 
    }
    
    return self;
    
    
};

-(MKAnnotationView *) annotationView
{
    MKAnnotationView * annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"Pin"];
    
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)];
    annotationView.rightCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)];
    return annotationView;
}

@end
