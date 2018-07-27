//
//  InterstitialViewController.m
//  Locality
//
//  Created by Youngmin Shin on 7/27/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "InterstitialViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "LoginViewController.h"

@interface InterstitialViewController () <CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocationCoordinate2D currentLocation;
@end

@implementation InterstitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapContinue:(id)sender {
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.delegate = self;
    if(CLLocationManager.locationServicesEnabled){
        [self.locationManager requestLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation * currentLocation = [[CLLocation alloc] init];
    currentLocation = [locations lastObject];
    self.currentLocation = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    [self performSegueWithIdentifier:@"segueToLogin" sender:nil];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"THERE WAS AN ERROR - %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error{
    NSLog(@"THERE WAS AN ERROR - %@", error);
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"segueToLogin"]){
        LoginViewController *logInViewController =[segue destinationViewController];
        logInViewController.lat = [NSNumber numberWithDouble:self.currentLocation.latitude];
        logInViewController.lon = [NSNumber numberWithDouble:self.currentLocation.longitude];
        
    }
}


@end
