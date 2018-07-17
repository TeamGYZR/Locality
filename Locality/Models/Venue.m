//
//  Venue.m
//  Locality
//
//  Created by Ginger Dudley on 7/17/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "Venue.h"

@implementation Venue

-(instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.category = dictionary[@"categories"][0][@"name"];
        
        NSString *urlPrefix = dictionary[@"categories"][0][@"icon"][@"prefix"];
        NSString *urlSuffix = dictionary[@"categories"][0][@"icon"][@"suffix"];
        NSString *urlString = [NSString stringWithFormat:@"%@bg_32%@", urlPrefix, urlSuffix];
        self.iconURL = [NSURL URLWithString:urlString];
        
        self.streetAddress = dictionary[@"location"][@"formattedAddress"][0];
        
        //warning- numbers might be persnikity depending on their type- nscf number, doubles and nsnumber etc
        self.latitude = dictionary[@"location"][@"lat"];
        self.longitude = dictionary[@"location"][@"lng"];
        self.idStr = dictionary[@"id"];
        
    }
    return self;
}

//method that returns venue objects when initalized with an array of separate location dictionaries

+(NSMutableArray *)venuesWithArray:(NSArray *)dictionaries{
    NSMutableArray *venues = [NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries) {
        Venue *venue = [[Venue alloc] initWithDictionary:dictionary];
        [venues addObject:venue];
    }
    //venues = an array of 30 Venue objects
    return venues;
}

@end
