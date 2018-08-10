//
//  pinVenueAnnotation.m
//  Locality
//
//  Created by Ginger Dudley on 8/2/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "pinVenueAnnotation.h"
#import <CoreLocation/CoreLocation.h>
#import "pinVenueAnnotationView.h"

@implementation pinVenueAnnotation

-(id)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    self.title = dictionary[@"name"];
    NSString *latitudeString = dictionary[@"latitude"];
    NSString *longitudeString = dictionary[@"longitude"];
    self.coordinate = CLLocationCoordinate2DMake([latitudeString doubleValue], [longitudeString doubleValue]);
    self.picture = dictionary[@"pictureData"];
    self.pinDescription = dictionary[@"description"];
    self.pinCategory = dictionary[@"category"];
    return self;
}
@end
