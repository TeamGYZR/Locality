//
//  ItineraryPin.m
//  Locality
//
//  Created by Youngmin Shin on 8/3/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "ItineraryPin.h"

@implementation ItineraryPin
@dynamic name;
@dynamic latitude;
@dynamic longitude;
@dynamic itinerary;
@dynamic pinPicture;
@dynamic pinDescription;

+ (nonnull NSString *)parseClassName {
    return @"ItineraryPin";
}
@end

