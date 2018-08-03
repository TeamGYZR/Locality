//
//  pinVenueAnnotationView.m
//  Locality
//
//  Created by Ginger Dudley on 8/2/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "pinVenueAnnotationView.h"

@implementation pinVenueAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.enabled = YES;
        self.canShowCallout = YES;
    }
    return self;
}

@end
