
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
@property (strong, nonatomic) UIImage *pinImage;
@property (strong, nonatomic) NSString *pinName;
@property (strong, nonatomic) NSString *pinDescription;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (strong, nonatomic) NSString *pinCategory;
@property (nonatomic) BOOL keyboardUp;

@end

@implementation CreateYourOwnViewController
#pragma mark - View Controller
- (void)viewDidLoad {
    [super viewDidLoad];
    self.itineraryDraft = [[Itinerary alloc]init];
    self.itineraryDraft.pinnedLocations = [[NSMutableArray alloc] init];
    self.viewOverMapView.alpha=0;
    self.mapView.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnOverlay)];
    [self.viewOverMapView addGestureRecognizer:tap];
    [self.navigationController.view addSubview:self.viewOverMapView];
    self.locationManager = [CLLocationManagerSingleton sharedSingleton].locationManager;
    [self.locationManager requestWhenInUseAuthorization];
    self.pathCoordinates = [[NSMutableArray alloc] init];
    self.pinCoordinates = [[NSMutableArray alloc] init];
    self.startTime = CACurrentMediaTime();
    self.mapView.showsUserLocation = YES;
    self.locationManager.distanceFilter = 5;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.buttonView.layer.cornerRadius = self.buttonView.frame.size.width / 2;
    self.buttonView.clipsToBounds = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
    self.keyboardUp = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:.1843 green:.28235 blue:.34509 alpha:1], NSFontAttributeName:[UIFont fontWithName:@"Dosis-Bold" size:21]}];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:.1843 green:.28235 blue:.34509 alpha:1], NSFontAttributeName:[UIFont fontWithName:@"Dosis-Regular" size:21]} forState:UIControlStateNormal];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}
- (void)viewWillDisappear:(BOOL)animated{
    self.locationManager.delegate = nil;
}
-(void) dismissView{
    //add pin to mapview before the view dismisses
    [UIView beginAnimations:@"FadeIn" context:nil];
    [UIView setAnimationDuration:0.1];
    [self.addpininfoview removeFromSuperview];
    [self.viewOverMapView setAlpha:0.0];
    [UIView commitAnimations];
}
-(void)keyboardWillShow{
    if(!self.keyboardUp){
        CGRect addPinFrame = self.addpininfoview.frame;
        addPinFrame.origin.y -= 100;
        [UIView animateWithDuration:0.5 animations:^{
            self.addpininfoview.frame = addPinFrame;
        }];
        self.keyboardUp = YES;
    }
}
-(void)keyboardWillHide{
    if(self.keyboardUp){
        CGRect addPinFrame = self.addpininfoview.frame;
        addPinFrame.origin.y += 100;
        [UIView animateWithDuration:0.5 animations:^{
            self.addpininfoview.frame = addPinFrame;
        }];
        self.keyboardUp = NO;
    }
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
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add Pin?" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.addpininfoview = [[AddPinInfoView alloc] init];
        self.addpininfoview.delegate = self;
        [self.addpininfoview setAlpha:0.0];
        [self.navigationController.view addSubview:self.addpininfoview];
        [UIView beginAnimations:@"FadeIn" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:1];
        [self.addpininfoview setAlpha:1.0];
        self.viewOverMapView.alpha=0.4;
        [UIView commitAnimations];
        //[self addPinToMapView];
       }];
    [alert addAction:cancelAction];
    [alert addAction:continueAction];
    [self presentViewController:alert animated:YES completion:^{
    }];
}
- (IBAction)didTapDone:(id)sender {
    [self.locationManager stopUpdatingLocation];
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
    [self addPathsToParse];
}

- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)handleTapOnOverlay{
    [self dismissView];
}
#pragma mark - Private Methods

-(void)didTapOutOfOverlay{
    
    
}
- (void) addCoordinatesToPinAndPathArray{
    [self.pinCoordinates addObject:self.currentLocation];
    [self.pathCoordinates addObject:self.currentLocation];
}

- (void)addPinToMapView{
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    NSInteger pinsCount = ([self.pinCoordinates count] - 1);
    CLLocation *currentPinLocation = [self.pinCoordinates objectAtIndex:pinsCount];
    annotation.coordinate = currentPinLocation.coordinate;
    annotation.title = @"Location";
    [self.mapView addAnnotation:annotation];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        pinVenueAnnotationView *annotationView = (pinVenueAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"PlacePin"];
        if (annotationView == nil) {
            annotationView = [[pinVenueAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"PlacePin"];
            annotationView.canShowCallout = true;
        }
        if ([self.pinCategory isEqualToString:@"Foodie"]) {
            annotationView.pinTintColor = [UIColor blueColor];
        } else if ([self.pinCategory isEqualToString:@"Entertainment"]){
            annotationView.pinTintColor = [UIColor redColor];
        } else {
            annotationView.pinTintColor = [UIColor grayColor];
        }
        return annotationView;
    }
    return nil;
}

-(void)addPinsToParse{
    NSUInteger pinsCount = [self.pinCoordinates count]-1;
    CLLocation *currentPin = [self.pinCoordinates objectAtIndex:pinsCount];
    NSString *latitudeString = [[NSNumber numberWithDouble:currentPin.coordinate.latitude] stringValue];
    NSString *longitudeString = [[NSNumber numberWithDouble:currentPin.coordinate.longitude] stringValue];
    PFFile *pictureData = nil;
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:latitudeString, @"latitude", longitudeString, @"longitude", nil];
    [self.itineraryDraft.pinnedLocations addObject:dictionary];
    if(self.pinImage){
        pictureData = [ItineraryPin getPFFileFromImage:self.pinImage];
    } else{
        pictureData = [ItineraryPin getPFFileFromImage:[UIImage imageNamed:@"defaultImage"]];
    }
    [self.itineraryDraft.pinnedLocations[pinsCount] setObject:pictureData forKey:@"pictureData"];
    if (self.pinDescription) {
        [self.itineraryDraft.pinnedLocations[pinsCount] setObject:self.pinDescription forKey:@"description"];
    }
    if (self.pinName) {
        [self.itineraryDraft.pinnedLocations[pinsCount] setObject:self.pinName forKey:@"name"];
    }
    if (self.pinCategory) {
        [self.itineraryDraft.pinnedLocations[pinsCount] setObject:self.pinCategory forKey:@"category"];
    }
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

#pragma mark - Delegate Methods
- (void)didTapViewCancel{
    [self dismissView];
}

-(void) didTapViewShareWithImage:(UIImage *)pinImage withName:(NSString *)pinName withDescription:(NSString *)pinDescription withCategory:(NSString *)category{
    self.pinName = nil;
    self.pinDescription = nil;
    self.pinCategory = nil;
    self.pinImage = pinImage;
    self.pinName = pinName;
    self.pinDescription = pinDescription;
    self.pinCategory = category;
    [self addCoordinatesToPinAndPathArray];
    [self addPinToMapView];
    [self dismissView];
    [self addPinsToParse];
}

#pragma mark - Error Handling
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
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
@end
