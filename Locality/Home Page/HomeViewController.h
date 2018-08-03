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
#import <CoreLocation/CoreLocation.h>



@interface HomeViewController : UIViewController<OFFlickrAPIRequestDelegate, UISearchControllerDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong,nonatomic) OFFlickrAPIContext *context;
@property (strong, nonatomic) OFFlickrAPIRequest *request;
@property (strong, nonatomic) NSString *apiKey;
@property (strong,nonatomic) NSString *sharedKey;
@property (strong, nonatomic) NSDictionary * photoResponseDictionary;
@property (nonatomic) CLLocationCoordinate2D currentLocation;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) CLGeocoder *geoCoder;
- (void)reverseGeocode:(CLLocation *)location;
@property (strong, nonatomic) NSString *cityName;
@property (weak, nonatomic) IBOutlet UILabel *labefiled;
@property  UIImage * image1;
@property  UIImage * image2;
@property UIImage * image3;



@end
