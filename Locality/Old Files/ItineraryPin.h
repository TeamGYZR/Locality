//
//  ItineraryPin.h
//  Locality
//
//  Created by Youngmin Shin on 8/3/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "PFObject.h"
#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Itinerary.h"

@interface ItineraryPin : PFObject<PFSubclassing>

@property (strong, nonatomic) Itinerary *itinerary;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;
@property (strong, nonatomic) PFFile *pinPicture;
@property (strong, nonatomic) NSString *pinDescription;

+ (void)postPinWithName:(NSString *)name withLatitude:(NSNumber *)latitude withLongitude:(NSNumber *)longitude withPicture:(UIImage *)picture withCompletion: (PFBooleanResultBlock  _Nullable)completion;

+ (PFFile *)getPFFileFromImage: (UIImage * _Nullable)image;
@end
