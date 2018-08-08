//
//  CreateYourOwnViewController.m
//  Locality
//
//  Created by Ginger Dudley on 7/30/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "CreateYourOwnViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "Itinerary.h"
#import "Path.h"
#import "PathFinalizationViewController.h"
#import "ItineraryPin.h"

#import "AddPinInfoView.h"

#import "CLLocationManagerSingleton.h"


//trying to get different pins to display on the map
#import "pinVenueAnnotation.h"
#import "pinVenueAnnotationView.h"

@interface CreateYourOwnViewController () <MKMapViewDelegate, CLLocationManagerDelegate,AddPinInfoViewDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) NSMutableArray *pathCoordinates;
@property (strong, nonatomic) NSMutableArray *pinCoordinates;
@property (nonatomic, retain) MKPolyline *polyline;
@property (strong, nonatomic) Itinerary *itineraryDraft;
@property (strong, nonatomic) NSData *imageData;
@property (strong, nonatomic) NSMutableArray *pinInfo;
@property (nonatomic) CFTimeInterval startTime;
@property (nonatomic) CFTimeInterval endTime;
@property (strong, nonatomic)  AddPinInfoView * addpininfoview;
@end

@implementation CreateYourOwnViewController
#pragma mark - View Controller
- (void)viewDidLoad {
    [super viewDidLoad];
    self.itineraryDraft = [[Itinerary alloc]init];
    self.itineraryDraft.pinnedLocations = [[NSMutableArray alloc] init];
    self.viewOverMapView.alpha=0;
    self.mapView.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)];
    [self.viewOverMapView addGestureRecognizer:tap];
    self.locationManager = [CLLocationManagerSingleton sharedSingleton].locationManager;
    [self.locationManager requestWhenInUseAuthorization];
    self.pathCoordinates = [[NSMutableArray alloc] init];
    self.pinCoordinates = [[NSMutableArray alloc] init];
    self.mapView.showsUserLocation = YES;
    self.locationManager.distanceFilter = 5;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //[self didTapViewCancel];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    self.startTime = CACurrentMediaTime();
}
- (void)viewWillDisappear:(BOOL)animated{
    self.locationManager.delegate = nil;
}
-(void) dismissView{
    [UIView beginAnimations:@"FadeIn" context:nil];
    [UIView setAnimationDuration:1];
    [self.addpininfoview setAlpha:0.0];
    [self.viewOverMapView setAlpha:0.0];
    [UIView commitAnimations];
    [self addPinsToParse];
}
#pragma mark - Location Updates
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    self.currentLocation = [locations lastObject];
    [self.pathCoordinates addObject:self.currentLocation];
    [self drawPath];
}

- (void)drawPath{
    NSUInteger pointsCount = [self.pathCoordinates count];
    if (pointsCount > 1) {
        if (self.polyline) {
            [self.mapView removeOverlay:self.polyline];
        }
        CLLocationCoordinate2D *coordinates = malloc(pointsCount * sizeof(CLLocationCoordinate2D));
        for (int i = 0; i < pointsCount; i++) {
            CLLocation *current = [self.pathCoordinates objectAtIndex:i];
            coordinates[i] = current.coordinate;
        }
        self.polyline = [MKPolyline polylineWithCoordinates:coordinates count:pointsCount];
        free(coordinates);
        [self.mapView addOverlay:self.polyline];
        [self.mapView setNeedsDisplay];
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer *pathRenderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        pathRenderer.fillColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        pathRenderer.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        pathRenderer.lineWidth = 3;
        return pathRenderer;
    }
    return nil;
}

#pragma mark - IBActions
- (IBAction)didTapAddPin:(id)sender {
    //add alert view controller to confirm that the user wanted to add the location, then continue- have an addPin method
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add Pin?" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
      self.addpininfoview=[[AddPinInfoView alloc] init];
      self.addpininfoview.delegate=self;
       [self.addpininfoview setAlpha:0.0];
       [self.view addSubview:self.addpininfoview];
        [UIView beginAnimations:@"FadeIn" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:1];
       [self.addpininfoview setAlpha:1.0];
        self.viewOverMapView.alpha=0.8;
      [UIView commitAnimations];
      [self addPinToMapView];
       }];
    [alert addAction:cancelAction];
    [alert addAction:continueAction];
    [self presentViewController:alert animated:YES completion:^{
    }];
}
- (IBAction)didTapDone:(id)sender {
    [self.locationManager stopUpdatingLocation];
    //self.itineraryDraft = [[Itinerary alloc] init];
    self.itineraryDraft.creator = [User currentUser];
    self.endTime = CACurrentMediaTime() - self.startTime;
    long minutes = floor(self.endTime/60);
    long seconds = round(self.endTime - (minutes * 60));
    if(seconds < 10){
    self.itineraryDraft.timeStamp = [NSString stringWithFormat:@"%lu:0%lu", minutes, seconds];
    }
    else{
    self.itineraryDraft.timeStamp = [NSString stringWithFormat:@"%lu:%lu", minutes, seconds];
    }
    //[self addPinsToParse];
    [self addPathsToParse];
}

- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
}
#pragma mark - Private Methods

- (void)addPinToMapView{
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    annotation.coordinate = self.currentLocation.coordinate;
    annotation.title = @"Location";
    [self.mapView addAnnotation:annotation];
    [self.pinCoordinates addObject:self.currentLocation];
    [self.pathCoordinates addObject:self.currentLocation];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        pinVenueAnnotationView *annotationView = (pinVenueAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"PlacePin"];
        if (annotationView == nil) {
            annotationView = [[pinVenueAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"PlacePin"];
            annotationView.canShowCallout = true;
        }
        return annotationView;
    }
    return nil;
}


- (void)addPinsToParse{
    NSUInteger pinsCount = [self.pinCoordinates count]-1;
    CLLocation *currentPin = [self.pinCoordinates objectAtIndex:pinsCount];
    NSString *latitudeString = [[NSNumber numberWithDouble:currentPin.coordinate.latitude] stringValue];
    NSString *longitudeString = [[NSNumber numberWithDouble:currentPin.coordinate.longitude] stringValue];
    PFFile *pictureData = nil;
    if(imageByTheUser){
        pictureData = [ItineraryPin getPFFileFromImage:imageByTheUser];
    }
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:latitudeString, @"latitude", longitudeString, @"longitude", pictureData, @"pictureData", nil];
    [self.itineraryDraft.pinnedLocations addObject:dictionary];
}
-(void)addPathsToParse{
    NSString *cgPointString = nil;
    self.itineraryDraft.paths = [[NSArray alloc] init];
    NSMutableArray *holderArray = [[NSMutableArray alloc] init];
    NSUInteger pathsCount = [self.pathCoordinates count];
    for (int i = 0; i < pathsCount; i++) {
        CLLocation *currentPin = [self.pathCoordinates objectAtIndex:i];
        CGPoint coordinatePoint = CGPointMake(currentPin.coordinate.latitude, currentPin.coordinate.longitude);
        cgPointString = NSStringFromCGPoint(coordinatePoint);
        holderArray[i] = cgPointString;
    }
    self.itineraryDraft.paths = [holderArray copy];
    [self performSegueWithIdentifier:@"doneSegue" sender:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *pinneddeditedPicture = info[UIImagePickerControllerEditedImage];
    self.imageData = UIImagePNGRepresentation(pinneddeditedPicture);
}

#pragma mark - Error Handling

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"There was an error with the current location manager: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error{
    NSLog(@"Error - locations updates will no longer be deferred: %@", error);
}
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"doneSegue"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        PathFinalizationViewController *pathFinalizationVC = (PathFinalizationViewController *)navigationController.topViewController;
        pathFinalizationVC.itinerary = self.itineraryDraft;
        pathFinalizationVC.pinInfo = self.pinInfo; 
    }
}
- (void)didTapViewCancel{
    [self addPinsToParse];
    [self dismissView];
}
-(void) didTapViewShare{
   [self addPinsToParse];
    [self dismissView];
}


@synthesize imageByTheUser;

@synthesize check;

@end
