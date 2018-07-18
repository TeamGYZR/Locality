//
//  VenueAnnotation.h
//  Locality
//
//  Created by Youngmin Shin on 7/17/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface VenueAnnotation : NSObject <MKAnnotation>

@property (readonly, nonatomic) CLLocationCoordinate2D * coordinate;
@property (strong, nonatomic) UIImage * image;
@property (strong, nonatomic) NSString * address;
@property (strong, nonatomic) NSString * name;

-(id)initWithName:(NSString *)name Coordinate:(CLLocationCoordinate2D *)coordinate Address:(NSString *)address AndImage:(UIImage *)image;
-(MKAnnotationView *) annotationView; 


@end
