//
//  APIManager.h
//  Locality
//
//  Created by Ginger Dudley on 7/17/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIManager : NSObject

@property (strong, nonatomic) NSArray *results;

-(void)fetchLocationsWithLatitude:(NSNumber *)lat andLongitude:(NSNumber *)longitude withCompletionHandler:(void(^)(NSArray *array, NSError *errror))completion;
-(void)fetchVenuewithVenueID:(NSString *)venueID; 

@end
