//
//  APIManager.h
//  Locality
//
//  Created by Ginger Dudley on 7/17/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Venue.h"

@interface APIManager : NSObject

@property (strong, nonatomic) NSArray *results;

-(void)fetchLocationsWithLatitude:(NSNumber *)lat andLongitude:(NSNumber *)longitude withCompletionHandler:(void(^)(NSArray *array, NSError *errror))completion;
-(void)fetchVenuewithVenueName:(NSString *)venueName Latitude:(NSNumber *)lat Longitude:(NSNumber *)lon withCompletionHandler:(void (^)(Venue *, NSError *))completion; 

@end
