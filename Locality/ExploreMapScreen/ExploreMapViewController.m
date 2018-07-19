//
//  ExploreMapViewController.m
//  Locality
//
//  Created by Youngmin Shin on 7/16/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "ExploreMapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "APIManager.h"
#import "Venue.h"
#import "VenueAnnotation.h"
#import "UIImageView+AFNetworking.h"


@interface ExploreMapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *currentLocationButton;
@property (strong, nonatomic) CLLocationManager *locationManager;
//@property (strong,nonatomic) NSString * string;

@end

@implementation ExploreMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mapView.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    

    [self.locationManager requestWhenInUseAuthorization];
    
    //if(CLLocationManager.locationServicesEnabled)
   // {
        if(CLLocationManager.authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse)
        {
            NSLog(@"location usage authorized");
            
            self.locationManager.distanceFilter = kCLDistanceFilterNone;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            
            [self findCurrentLocation];
            //self.mapView.showsUserLocation = YES;
            
//            MKCoordinateRegion sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667), MKCoordinateSpanMake(0.1, 0.1));
//            [self.mapView setRegion:sfRegion animated:false];
        }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)findCurrentLocation{
   // [self.locationManager startUpdatingLocation];
   [self.locationManager requestLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    CLLocation * currentLocation = [[CLLocation alloc] init];
    
    currentLocation = [locations lastObject];
    
    
    NSLog(@"lat: %f, long: %f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    
    MKCoordinateRegion currentRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude), MKCoordinateSpanMake(0.025, 0.025));
    
    
    [self.mapView setRegion:currentRegion animated:YES];
    
    CLLocationCoordinate2D pinCoordinates = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    
    NSURL * currentImageURL = [NSURL URLWithString:@"https://banner2.kisspng.com/20180327/prw/kisspng-emoji-discord-meme-android-imgur-thinking-5ab9e09a302f12.8060406115221310981974.jpg"];
    VenueAnnotation *annotation = [[VenueAnnotation alloc]  initWithName:@"Current Location" Coordinate:pinCoordinates Address:@"Here" AndImageurl:currentImageURL];
    [self.mapView addAnnotation:annotation];
    
    
    APIManager *apiManager = [[APIManager alloc] init];
    NSNumber * lat = [NSNumber numberWithDouble:currentLocation.coordinate.latitude];
    NSNumber * lon = [NSNumber numberWithDouble:currentLocation.coordinate.longitude];
    
    [apiManager fetchLocationsWithLatitude:lat andLongitude:lon withCompletionHandler:^(NSArray *array, NSError *errror) {
        NSLog(@"completion ran");
        
        for(Venue *venue in array){
//            MKPointAnnotation *annotation = [MKPointAnnotation new];
//            CLLocationCoordinate2D pinCoordinates = CLLocationCoordinate2DMake(venue.latitude.doubleValue, venue.longitude.doubleValue);
//            annotation.coordinate = pinCoordinates;
//            annotation.title = venue.name;
//            [self.mapView addAnnotation:annotation];
            //put above in for loop when data is received from api
            
            VenueAnnotation *annotation = [[VenueAnnotation alloc] initWithVenue:venue];
//            CLLocationCoordinate2D pinCoordinates = CLLocationCoordinate2DMake(venue.latitude.doubleValue, venue.longitude.doubleValue);
//            annotation.coordinate = pinCoordinates;
//            annotation.title = venue.name;
            [self.mapView addAnnotation:annotation];
        }
        
        
        [self.navigationController popToViewController:self animated:YES];
        //self.mapView.showsUserLocation = YES;
    }];



    
    
    
    //[self.mapView.userLocation  ]
    
    
}
- (IBAction)getCurrentLocationTapped:(id)sender {
    [self.locationManager requestLocation];
    
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    // Center the map the first time we get a real location change.
    static dispatch_once_t centerMapFirstTime;
    
    if ((userLocation.coordinate.latitude != 0.0) && (userLocation.coordinate.longitude != 0.0)) {
        dispatch_once(&centerMapFirstTime, ^{
            [self.mapView setCenterCoordinate:userLocation.coordinate animated:YES];
        });
    }
    
    NSLog(@"%f, %f", self.mapView.userLocation.coordinate.latitude, self.mapView.userLocation.coordinate.longitude);
    //send info to api manager
    
    
}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(VenueAnnotation *)annotation{
    MKPinAnnotationView * annotationView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
    
    if(annotationView == nil){
        
        annotationView =[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
        annotationView.canShowCallout = true;
        //annotationView.frame = CGRectMake(0.0, 0.0, 200.0, 200.0);
        //annotationView.detailCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 200.0)];
        annotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)];
        annotationView.rightCalloutAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)];
    }
    
    UIImageView *iconView = (UIImageView*)annotationView.leftCalloutAccessoryView;
    [iconView setImageWithURL:annotation.imageURL];
    
    UIButton *collectionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    //[collectionButton addTarget:self action:@selector(goToCollection:) forControlEvents:UIControlEventTouchUpInside];
    [collectionButton setTitle:@"Details" forState:UIControlStateNormal];
    collectionButton.frame = CGRectMake(0.0, 0.0, 50.0, 50.0);
    [collectionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    //[annotationView.rightCalloutAccessoryView addSubview:collectionButton];
    [annotationView.rightCalloutAccessoryView setUserInteractionEnabled:YES];
    annotationView.rightCalloutAccessoryView = collectionButton;
    
    return annotationView;
    
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
//    self.data.name= view.annotation.title;
    //self.string=view.annotation.title;
    [self performSegueWithIdentifier:@"collectionSegue" sender:view.annotation];
    
    //Here, the annotation tapped can be accessed using view.annotation
}




- (IBAction)goToCollection:(id)sender{

    NSLog(@"Went to collection view");
    
};

//-(void)goToCollection{
//
//    NSLog(@"Went to collection view");
//}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"%@", error);
}

- (void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error{
    NSLog(@"%@", error);
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"collectionSegue"]){
        
        CollectionViewController * collection=[segue destinationViewController];
        collection.name = ((MKPointAnnotation *)sender).title;
        
    }
}


@end
