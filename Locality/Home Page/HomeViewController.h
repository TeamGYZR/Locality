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

@interface HomeViewController : UIViewController<OFFlickrAPIRequestDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong,nonatomic) OFFlickrAPIContext *context;
@property (strong, nonatomic) OFFlickrAPIRequest *request;
@property (strong, nonatomic) NSString *apiKey;
@property (strong,nonatomic) NSString *sharedKey;
@property (nonatomic) CLLocationCoordinate2D currentLocation;

@end
