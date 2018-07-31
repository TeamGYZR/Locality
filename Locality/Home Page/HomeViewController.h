//
//  HomeViewController.h
//  Locality
//
//  Created by Zelalem Tenaw Terefe on 7/27/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ObjectiveFlickr/ObjectiveFlickr.h>
#import <CoreLocation/CoreLocation.h>
#import "Parse.h"
#import "PathCell.h"
#import "math.h"
#import "User.h"
#import <MapKit/MapKit.h>

@interface HomeViewController : UIViewController<OFFlickrAPIRequestDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong,nonatomic) OFFlickrAPIContext *context;
@property (strong, nonatomic) OFFlickrAPIRequest *request1;
@property (strong, nonatomic) OFFlickrAPIRequest *request2;
@property (strong, nonatomic) NSString *apiKey;
@property (strong,nonatomic) NSString *sharedKey;
@property (strong, nonatomic) NSDictionary * photoResponseDictionary;
@property (nonatomic) CLLocationCoordinate2D currentLocation;
@property (weak, nonatomic) IBOutlet UITableView *tableView;



@end
