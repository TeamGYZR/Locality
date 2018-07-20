//
//  Venue.h
//  Locality
//
//  Created by Ginger Dudley on 7/17/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface Venue : NSObject

//make sure all of these variables are of the correct type
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSURL *iconURL;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSString *streetAddress;
@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, strong) NSURL *headerPicURL;

//rename these variables to match up w the type being sent in etc.
+(NSMutableArray *)venuesWithArray:(NSArray *)dictionaries;

-(instancetype)initWithDictionary: (NSDictionary *)dictionary;



@end
