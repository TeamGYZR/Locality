//
//  TestPathsViewController.m
//  Locality
//
//  Created by Youngmin Shin on 7/29/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "TestPathsViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "Itinerary.h"
#import "Path.h"
#import "PathDetailsViewController.h"

@interface TestPathsViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) NSMutableArray *pathCoordinates;
@property (nonatomic, retain) MKPolyline* polyline;
@property (strong, nonatomic) NSMutableArray *pinCoordinates;
@property (strong, nonatomic) Itinerary *fetchedItinerary;
//@property (strong, nonatomic) const CLLocationCoordinate2D *coordinatesForPath;

@end

@implementation TestPathsViewController

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
    [self.locationManager requestLocation];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation * currentLocation = [[CLLocation alloc] init];
    self.currentLocation = [locations lastObject];
    [self.pathCoordinates addObject:self.currentLocation];
    [self drawPath];
}

-(void)drawPath{
    NSUInteger numPoints = [self.pathCoordinates count];
    if (numPoints > 1)
    {
        if(self.polyline){
            [self.mapView removeOverlay:self.polyline];
        }
        CLLocationCoordinate2D* coords = malloc(numPoints * sizeof(CLLocationCoordinate2D));
        for (int i = 0; i < numPoints; i++)
        {
            CLLocation* current = [self.pathCoordinates objectAtIndex:i];
            coords[i] = current.coordinate;
        }
        
        
        self.polyline = [MKPolyline polylineWithCoordinates:coords count:numPoints];
        free(coords);
        
        [self.mapView addOverlay:self.polyline];
        [self.mapView setNeedsDisplay];
    }

    
}


- (IBAction)didTapStartPath:(id)sender {
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    [self.locationManager startUpdatingLocation];
    
}

- (IBAction)didTapStopPath:(id)sender {
    [self.locationManager stopUpdatingLocation];
    Itinerary * createdItinerary = [[Itinerary alloc] init];
    createdItinerary.name = @"test 1";
    createdItinerary.creator = [User currentUser];
    createdItinerary.pathDescription = @"test description";
    createdItinerary.category = @"test";
    createdItinerary.pinnedLocations = [[NSMutableArray alloc] init];
    NSUInteger numPins = [self.pinCoordinates count];
    for (int i = 0; i < numPins; i++)
    {
        CLLocation* current = [self.pinCoordinates objectAtIndex:i];
        CGPoint testPoint = CGPointMake(current.coordinate.latitude, current.coordinate.longitude);
        NSString * test = [[NSString alloc] init];
        test = NSStringFromCGPoint(testPoint);
        createdItinerary.pinnedLocations[i] = test;
    }
    
    createdItinerary.paths = [[NSArray alloc] init];
    NSMutableArray *testArray = [[NSMutableArray alloc] init];
    NSUInteger numPoints = [self.pathCoordinates count];
    for (int i = 0; i < numPoints; i++)
    {
        CLLocation* current = [self.pathCoordinates objectAtIndex:i];
        CGPoint testPoint = CGPointMake(current.coordinate.latitude, current.coordinate.longitude);
        NSString * test = [[NSString alloc] init];
        test = NSStringFromCGPoint(testPoint);
        testArray[i] = test;
    }
    
    createdItinerary.paths = [testArray copy];
    //createdItinerary.paths = createdPath;
    [createdItinerary saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if(succeeded){
            NSLog(@"succeeded!");
        }
    }];
    
}

- (IBAction)didTapDropPin:(id)sender {
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    annotation.coordinate = self.currentLocation.coordinate;
    annotation.title = @"Location";
    [self.mapView addAnnotation:annotation];
    [self.pinCoordinates addObject:self.currentLocation];
    [self.pathCoordinates addObject:self.currentLocation];
    //NSLog(@"huh?");
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView
            rendererForOverlay:(id<MKOverlay>)overlay{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineRenderer *pathRenderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        
        pathRenderer.fillColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        pathRenderer.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        pathRenderer.lineWidth = 3;
        
        return pathRenderer;
    }
    
    return nil;
    
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"THERE WAS AN ERROR - %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error{
    NSLog(@"THERE WAS AN ERROR - %@", error);
}

- (IBAction)didTapTest:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"Itinerary"];
    [query includeKeys:@[@"creator", @"createdAt"]];
    [query getObjectInBackgroundWithId:@"TeaICYP70d" block:^(PFObject *testItinerary, NSError *error) {
        // Do something with the returned PFObject in the gameScore variable.
        
        self.fetchedItinerary = (Itinerary *)testItinerary;
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"seguePathDetail"]){
        UINavigationController *navigationController = [segue destinationViewController];
        PathDetailsViewController *pathDetailsController = (PathDetailsViewController*)navigationController.topViewController;
        pathDetailsController.itinerary = self.fetchedItinerary;
        
    }
}


@end
