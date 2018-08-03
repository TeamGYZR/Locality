//
//  pinVenueAnnotation.h
//  Locality
//
//  Created by Ginger Dudley on 8/2/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface pinVenueAnnotation : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) NSString *title;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (MKAnnotationView *)annotationView;

@end
