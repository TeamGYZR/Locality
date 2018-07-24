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
#import "VenueAnnotationView.h"
#import "ResultsTableViewController.h"


@interface ExploreMapViewController () <MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *currentLocationButton;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) ResultsTableViewController * resultsController;
@end

@implementation ExploreMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mapView.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    
    
    self.resultsController = [[ResultsTableViewController alloc] init];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultsController];
    
    self.searchController.searchResultsUpdater = self;
    self.navigationItem.titleView = self.searchController.searchBar;
    
    self.searchController.searchBar.placeholder = @"Where to?";
    [self.searchController.searchBar sizeToFit];

    
    
    // we want to be the delegate for our filtered table so didSelectRowAtIndexPath is called for both tables
    self.resultsController.tableView.delegate = self;
    self.searchController.delegate = self;
    self.searchController.obscuresBackgroundDuringPresentation = YES;
    self.searchController.searchBar.delegate = self;
    self.definesPresentationContext = YES;
    
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    if(CLLocationManager.locationServicesEnabled)
    {
        //[MKUserTrackingButton userTrackingButtonWithMapView:self.mapView];
        
        if(CLLocationManager.authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse)
        {
            NSLog(@"location usage authorized");
            
            self.locationManager.distanceFilter = kCLDistanceFilterNone;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            
            [self findCurrentLocation];
            self.mapView.showsUserLocation = YES;
            
        }

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)findCurrentLocation{
   // [self.locationManager startUpdatingLocation]; // if we want real time updates
   [self.locationManager requestLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    CLLocation * currentLocation = [[CLLocation alloc] init];
    
    currentLocation = [locations lastObject];
    
    
    NSLog(@"lat: %f, long: %f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    
    MKCoordinateRegion currentRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(currentLocation.coordinate.latitude +0.001, currentLocation.coordinate.longitude), MKCoordinateSpanMake(0.025, 0.025));
    
    
    [self.mapView setRegion:currentRegion animated:YES];
    

//    NSURL * currentImageURL = [NSURL URLWithString:@"https://banner2.kisspng.com/20180327/prw/kisspng-emoji-discord-meme-android-imgur-thinking-5ab9e09a302f12.8060406115221310981974.jpg"];
    // in case we need another dummy emoticon

    
    
    APIManager *apiManager = [[APIManager alloc] init];
    NSNumber * lat = [NSNumber numberWithDouble:currentLocation.coordinate.latitude];
    NSNumber * lon = [NSNumber numberWithDouble:currentLocation.coordinate.longitude];
    
    [apiManager fetchLocationsWithLatitude:lat andLongitude:lon withCompletionHandler:^(NSArray *array, NSError *errror) {
        
        NSLog(@"completion ran");
        for(Venue *venue in array){
            VenueAnnotation *annotation = [[VenueAnnotation alloc] initWithVenue:venue];
            [self.mapView addAnnotation:annotation];
        }
        
        [self.navigationController popToViewController:self animated:YES];
    }];
    
}
- (IBAction)getCurrentLocationTapped:(id)sender {
    [self.locationManager requestLocation];
    
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSLog(@"search bar text changed OIOIOIO");
    
};


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    
    if([annotation isKindOfClass:[VenueAnnotation class]])
    {
   MKPinAnnotationView * annotationView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
  
        if(annotationView == nil){
        annotationView =[[VenueAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
        annotationView.canShowCallout = true;
            }
        
        
        VenueAnnotation *venueAnnotation = (VenueAnnotation *)annotation;
        
        if([venueAnnotation.category isEqualToString:@"Coffee Shop"]){
            annotationView.pinTintColor = [UIColor brownColor];
        }
        else if([venueAnnotation.category isEqualToString:@"Bakery"]){
            annotationView.pinTintColor = [UIColor colorWithRed:1.0 green:0.745 blue:0.0 alpha:1];
        }
            UIImageView *iconView = (UIImageView*)annotationView.leftCalloutAccessoryView;
            [iconView setImageWithURL: venueAnnotation.imageURL];
        
            UIButton *collectionButton = [UIButton buttonWithType:UIButtonTypeSystem];
            [collectionButton setTitle:@"Pics" forState:UIControlStateNormal];
            collectionButton.frame = CGRectMake(0.0, 0.0, 50.0, 50.0);
            [collectionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [annotationView.rightCalloutAccessoryView setUserInteractionEnabled:YES];
            annotationView.rightCalloutAccessoryView = collectionButton;
        
        return annotationView;
        
    }

    return nil; 
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{

    [self performSegueWithIdentifier:@"collectionSegue" sender:view.annotation];
    
    //Here, the annotation tapped can be accessed using view.annotation
}


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
        collection.venue = ((VenueAnnotation * )sender).venue;
        
    }
}


@end
