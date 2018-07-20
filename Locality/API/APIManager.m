//
//  APIManager.m
//  Locality
//
//  Created by Ginger Dudley on 7/17/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "APIManager.h"
#import "Venue.h"

@implementation APIManager


-(void)fetchLocationsWithLatitude:(NSNumber *)lat andLongitude:(NSNumber *)longitude withCompletionHandler:(void (^)(NSArray *, NSError *))completion{
    static NSString *const clientID = @"GCWUZIHYLK1DURPIEVO4HYRNIRUDC2NBKJHEPLE4RFMLQ35A";
    static NSString *const clientSecret = @"VRCUJCWQYIWBFK212OOGGGU1KD2DKZLYVZZJ0ZUNEIBNA5EV";
    
    NSString *baseURLstring = @"https://api.foursquare.com/v2/venues/explore?";
    
    //fetch top picks in area from foursquare
    NSString *coordinateString = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&v=20180716&ll=%@,%@&section=topPicks", clientID, clientSecret, lat, longitude];
    coordinateString = [coordinateString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:[baseURLstring stringByAppendingString:coordinateString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.results = [responseDictionary valueForKeyPath:@"response.groups.items.venue"][0];
            NSMutableArray *testerArray = [Venue venuesWithArray:self.results];
            completion(testerArray, error);
        }
        else{
            completion(nil, error);
        }
    }];
    
    [task resume];
    
}

@end
