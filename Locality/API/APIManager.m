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

//-(void)fetchNearbyVenuesWithCompletion:(void (^)(NSArray *, NSError *))completion{
//    static NSString *const clientID = @"GCWUZIHYLK1DURPIEVO4HYRNIRUDC2NBKJHEPLE4RFMLQ35A";
//    static NSString *const clientSecret = @"VRCUJCWQYIWBFK212OOGGGU1KD2DKZLYVZZJ0ZUNEIBNA5EV";
//    
//}

-(void)fetchLocationsWithLatitude:(NSNumber *)lat andLongitude:(NSNumber *)longitude{
    static NSString *const clientID = @"GCWUZIHYLK1DURPIEVO4HYRNIRUDC2NBKJHEPLE4RFMLQ35A";
    static NSString *const clientSecret = @"VRCUJCWQYIWBFK212OOGGGU1KD2DKZLYVZZJ0ZUNEIBNA5EV";
    
    NSString *baseURLstring = @"https://api.foursquare.com/v2/venues/explore?";
    
    NSString *coordinateString = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&v=20180716&ll=%@,%@", clientID, clientSecret, lat, longitude];
    coordinateString = [coordinateString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:[baseURLstring stringByAppendingString:coordinateString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            //creating a dictionary to hold the json data
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            //printing out the json data to view the responses based on the specific coordinates
            //NSLog(@"response: %@", responseDictionary);
            //using the venue names as the query
            self.results = [responseDictionary valueForKeyPath:@"response.groups.items.venue"][0];
            
            //set this equal to something else- comes back as an array of objects
            [Venue venuesWithArray:self.results];
            //NSMutableArray *testerArray = [Venue venuesWithArray:self.results];
            //NSLog(@"%@", testerArray);
            //NSString *tester = @"tester";
            //NSLog(@"%@", [Venue venuesWithArray:self.results]);
            
        }
    }];
    [task resume];
    
    //either put this before or after task resume- unsure
    //NSMutableArray *venue = [Venue venuesWithArray:self.results];
    
    //cakking the venues with array function to set all of the objects up!
    //[Venue venuesWithArray:self.results];
    
}

@end
