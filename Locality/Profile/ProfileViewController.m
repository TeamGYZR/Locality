//
//  ProfileViewController.m
//  Locality
//
//  Created by Ginger Dudley on 7/19/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "ProfileViewController.h"
#import "EditProfileViewController.h"
#import "ParseUI/ParseUI.h"
#import "APImanager.h"
#import "FavoriteCell.h"
#import "Favorite.h"
#import "AppDelegate.h"
#import <MapKit/Mapkit.h>
#import <CoreLocation/CoreLocation.h>
#import "Venue.h"
#import "VenueAnnotation.h"
#import "UIImageView+AFNetworking.h"
#import "VenueAnnotationView.h"

@interface ProfileViewController () <FavoriteCellDelegate, MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet PFImageView *profiePicImageView;
@property (strong, nonatomic) NSArray * favorites;
//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) APIManager *apimanager;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [User currentUser];
    
    if (self.user.name == nil) {
        self.nameLabel.text = self.user.username;
    }
    else{
        self.nameLabel.text = self.user.name;
    }
    [self.nameLabel sizeToFit];
    if (self.user.profilePicture != nil) {
        self.profiePicImageView.file = self.user.profilePicture;
        [self.profiePicImageView loadInBackground];
    }
    
    self.apimanager = [APIManager new];
    
    self.mapView.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if(CLLocationManager.locationServicesEnabled)
    {
        //[MKUserTrackingButton userTrackingButtonWithMapView:self.mapView];
        
        if(CLLocationManager.authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse)
        {
            NSLog(@"location usage authorized");
            
            self.locationManager.distanceFilter = kCLDistanceFilterNone;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            
            [self loadFavorites];
            //self.mapView.showsUserLocation = YES;
            
        }
        
    }
    
    
    
    
    
    

}

- (IBAction)didTapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        ProfileViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        appDelegate.window.rootViewController = loginViewController;
    }];
}


-(void)loadFavorites{
    PFQuery *query = [PFQuery queryWithClassName:@"Favorite"];
    [query whereKey:@"user" equalTo: self.user];
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *favorites, NSError *error) {
        if ([favorites count] != 0) {
            // do something with the array of object returned by the call
            self.favorites = favorites;
            [self.locationManager requestLocation];
        } else {
            NSLog(@"Could not find any favorites - %@", error.localizedDescription);
        }
    }];
    
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    CLLocation * currentLocation = [[CLLocation alloc] init];
    
    currentLocation = [locations lastObject];
    
    
    NSLog(@"lat: %f, long: %f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    
    MKCoordinateRegion currentRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude), MKCoordinateSpanMake(0.075, 0.075));
    
    
    [self.mapView setRegion:currentRegion animated:YES];
//    NSNumber * lat = [NSNumber numberWithDouble:currentLocation.coordinate.latitude];
//    NSNumber * lon = [NSNumber numberWithDouble:currentLocation.coordinate.longitude];

        for(Favorite *favorite in self.favorites){
            [self.apimanager fetchVenuewithVenueName:favorite.venueName Latitude:favorite.latitude Longitude:favorite.longitude withCompletionHandler:^(Venue * venue, NSError * error){
                if(venue){
                    VenueAnnotation *annotation = [[VenueAnnotation alloc] initWithVenue:venue];
                    [self.mapView addAnnotation:annotation];
                    
                }
                else{
                    NSLog(@"no favorites");
                }
                
                
            }];
            

        }

}


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
        
        UIButton *collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [collectionButton setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
        collectionButton.frame = CGRectMake(0.0, 0.0, 25.0, 25.0);
 
        [annotationView.rightCalloutAccessoryView setUserInteractionEnabled:YES];
        annotationView.rightCalloutAccessoryView = collectionButton;
        
        return annotationView;
        
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    VenueAnnotation * venueAnnotation = (VenueAnnotation *)view.annotation;
    [Favorite removeVenue:(Venue * _Nullable)venueAnnotation.venue withCompletion:^(BOOL worked, NSError * _Nullable __strong error){
        if(error)
        {
            NSLog(@"favorite deletion did not work :( - %@", error.localizedDescription);
        }
        else{
            [self.mapView removeAnnotation:view.annotation];
            [self loadFavorites];
            NSLog(@"favorite successfully deleted :D");
        }
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [self viewDidLoad];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"%@", error);
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"editProfileSegue"]) {
        self.user = [User currentUser];
        EditProfileViewController *editProfViewController = segue.destinationViewController;
        editProfViewController.user = self.user;
    }
}


@end
