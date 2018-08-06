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

+ (void)postPinWithName:(NSString *)name withLatitude:(NSNumber *)latitude withLongitude:(NSNumber *)longitude withPicture:(UIImage *)picture withCompletion:(PFBooleanResultBlock _Nullable)completion{
    ItineraryPin *currentPin = [ItineraryPin alloc];
    currentPin.name = name;
    currentPin.latitude = latitude;
    currentPin.longitude = longitude;
    currentPin.pinPicture = [ItineraryPin getPFFileFromImage:picture];
    
    [currentPin saveInBackgroundWithBlock:^(BOOL worked, NSError *error){
        if(worked)
        {
            NSLog(@"pin saved");
            completion(worked, error);
        }
        else{
            NSLog(@"error - %@", error.localizedDescription);
        }
        
    }];
}

+ (PFFile *)getPFFileFromImage: (UIImage * _Nullable)image {
    // check if image is not nil
    if (!image) {
        return nil;
    }
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    return [PFFile fileWithName:@"image.png" data:imageData];
}
@end



