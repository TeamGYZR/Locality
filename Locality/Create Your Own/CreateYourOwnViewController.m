//
//  CreateYourOwnViewController.m
//  Locality
//
//  Created by Ginger Dudley on 7/30/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "CreateYourOwnViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "Itinerary.h"
#import "Path.h"

@interface CreateYourOwnViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) NSMutableArray *pathCoordinates;
@property (strong, nonatomic) NSMutableArray *pinCoordinates;
@property (nonatomic, retain) MKPolyline *polyline;



@end

@implementation CreateYourOwnViewController

#pragma mark - View Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    self.pathCoordinates = [[NSMutableArray alloc] init];
    self.pinCoordinates = [[NSMutableArray alloc] init];
    self.mapView.showsUserLocation = YES;
    self.locationManager.distanceFilter = 5;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
}

#pragma mark - Location Updates

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    self.currentLocation = [locations lastObject];
    [self.pathCoordinates addObject:self.currentLocation];
    [self drawPath];
}

- (void)drawPath{
    NSUInteger numPoints = [self.pathCoordinates count];
    if (numPoints > 1) {
        if (self.polyline) {
            [self.mapView removeOverlay:self.polyline];
        }
        CLLocationCoordinate2D *coords = malloc(numPoints * sizeof(CLLocationCoordinate2D));
        for (int i = 0; i < numPoints; i++) {
            CLLocation *current = [self.pathCoordinates objectAtIndex:i];
            coords[i] = current.coordinate;
        }
    }
    
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
