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
    return venues;
}

+(NSDictionary *)dictionaryFromVenue:(Venue *)venue{

    NSMutableDictionary * dictionary = [NSMutableDictionary new];
    dictionary[@"name"] = venue.name;
    dictionary[@"category"] = venue.category;
    dictionary[@"iconURLString"] = [venue.iconURL absoluteString];
    dictionary[@"formattedAddress"] = venue.streetAddress;
    dictionary[@"lat"] = venue.latitude;
    dictionary[@"lng"] = venue.longitude;
    dictionary[@"id"] = venue.idStr;
    dictionary[@"headerURLString"] = [venue.headerPicURL absoluteString];
    
    NSDictionary * venueDictionary = [dictionary copy];
    
    return venueDictionary;
}

-(instancetype)venueFromDictionary:(NSDictionary *)dictionary{
    Venue * venue = [Venue new];
    
    if (venue) {
        venue.name = dictionary[@"name"];
        venue.category = dictionary[@"category"];
        venue.iconURL = [NSURL URLWithString:dictionary[@"iconURLString"]];
        venue.streetAddress = dictionary[@"formattedAddress"];
        venue.latitude = dictionary[@"lat"];
        venue.longitude = dictionary[@"lng"];
        venue.idStr = dictionary[@"id"];
        venue.headerPicURL = [NSURL URLWithString:dictionary[@"headerURLString"]];;
        
    }
    return venue;
    
    
}



@end
