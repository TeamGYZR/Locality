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

@interface ExploreMapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *currentLocationButton;
@property (strong, nonatomic) CLLocationManager *locationManager;

//- (void)locationManager:(CLLocationManager *)manager
//     didUpdateLocations:(NSArray<CLLocation *> *)locations;
-(void)goToCollection;

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
    
    
    //CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude.floatValue, longitude.floatValue);
    
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    CLLocationCoordinate2D pinCoordinates = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude + 0.001, currentLocation.coordinate.longitude + 0.001);
    annotation.coordinate = pinCoordinates;
    annotation.title = @"Picture!";
    [self.mapView addAnnotation:annotation];
    
    [self.navigationController popToViewController:self animated:YES];
    self.mapView.showsUserLocation = YES;
    
    //[self.mapView.userLocation  ]
    
    
}
- (IBAction)getCurrentLocationTapped:(id)sender {
    [self.locationManager requestLocation];
    
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    MKPinAnnotationView * annotationView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
    
    if(annotationView == nil){
        
        annotationView =[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
        annotationView.canShowCallout = true;
        annotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)];
        annotationView.rightCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)];
    }
    
    UIImageView *imageView = (UIImageView*)annotationView.leftCalloutAccessoryView;
    imageView.image = [UIImage imageNamed:@"frenchfries"];
    
    UIButton *collectionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [collectionButton addTarget:self action:@selector(goToCollection) forControlEvents:UIControlEventTouchUpInside];
    [collectionButton setTitle:@"Hi" forState:UIControlStateNormal];
    collectionButton.frame = CGRectMake(0.0, 0.0, 50.0, 50.0);
    [collectionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    [annotationView.rightCalloutAccessoryView addSubview:collectionButton];
    [annotationView.rightCalloutAccessoryView setUserInteractionEnabled:YES];
    
    return annotationView;
    
}

- (void)makePins{
    
    
}

-(void)goToCollection{
    NSLog(@"Went to collection view");
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"%@", error);
}

- (void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error{
    NSLog(@"%@", error);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
