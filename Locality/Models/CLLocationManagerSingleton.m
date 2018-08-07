//
//  CLLocationManagerSingleton.m
//  Locality
//
//  Created by Youngmin Shin on 8/7/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "CLLocationManagerSingleton.h"

@implementation CLLocationManagerSingleton

+ (instancetype)sharedSingleton{
    static CLLocationManagerSingleton *sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSingleton= [[self alloc] init];
    });
    return sharedSingleton;
}

- (instancetype)init{
    self = [super init];
    if(self){
        self.locationManager = [CLLocationManager new];
    }
    return self;
}

@end
