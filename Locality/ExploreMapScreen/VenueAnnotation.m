//
//  VenueAnnotation.m
//  Locality
//
//  Created by Youngmin Shin on 7/17/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "VenueAnnotation.h"


@implementation VenueAnnotation

-(id)initWithName:(NSString *)name Coordinate:(CLLocationCoordinate2D *)coordinate Address:(NSString *)address AndImage:(UIImage *)image{
    
    self = [super init];
    
    if(self)
    {
        _name = name;
        _coordinate = coordinate;
        _address = address;
        _image = image;
    }
    
    return self; 
    
    
    
}

-(MKAnnotationView *) annotationView
{
    MKAnnotationView * annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"VenueAnnotation"];
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    
    // button + image ?
    
    return annotationView;
}

@end
