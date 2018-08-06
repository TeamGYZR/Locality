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
#import "PathFinalizationViewController.h"
#import "ItineraryPin.h"

@interface CreateYourOwnViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) NSMutableArray *pathCoordinates;
@property (strong, nonatomic) NSMutableArray *pinCoordinates;
@property (nonatomic, retain) MKPolyline *polyline;
@property (strong, nonatomic) Itinerary *itineraryDraft;
@property (strong, nonatomic) NSData *imageData;
@property (strong, nonatomic) NSMutableArray *pinInfo;
@end

@implementation CreateYourOwnViewController
#pragma mark - View Controller
- (void)viewDidLoad {
    [super viewDidLoad];
    self.progressView.alpha=0;
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    [self.locationManager startUpdatingLocation];
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
       
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Do you want to add info about it?" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *infoAction = [UIAlertAction actionWithTitle:@"Add Info" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //UIView *messageView = [[UIView alloc] init];
            self.progressView=[[UIView alloc] init];
            CGRect viewBounds = self.view.bounds;
          self.progressView.frame = CGRectMake((viewBounds.size.width / 2)-179.5, viewBounds.size.height/2-150, 350, 250);
           self.progressView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
            self.progressView.backgroundColor = [UIColor whiteColor];
            self.progressView.layer.cornerRadius = 8.0;
            self.progressView.layer.shadowOffset = CGSizeZero;
            self.progressView.layer.shadowOpacity = 0.5;
            //[overlayView addSubview:messageView];
            [self.view addSubview:self.progressView];
         }];
       UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           }];
        
        [alert addAction:infoAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        [self addPinToMapView];
       
    }];
    
    [alert addAction:continueAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

- (IBAction)didTapDone:(id)sender {
    [self.locationManager stopUpdatingLocation];
    self.itineraryDraft = [[Itinerary alloc] init];
    self.itineraryDraft.creator = [User currentUser];
    [self addPinsToParse];
}

- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)didTapAddPhoto:(id)sender {
    UIImagePickerController *imagePicker = [UIImagePickerController new];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else{
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePicker animated: YES completion:nil];
}

- (IBAction)didtapDone:(id)sender {
    self.progressView.alpha=0;
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

- (void)addPinsToParse{
    self.itineraryDraft.pinnedLocations = [[NSMutableArray alloc] init];
    NSUInteger pinsCount = [self.pinCoordinates count];
    for (int i = 0; i < pinsCount; i++) {
        CLLocation *currentPin = [self.pinCoordinates objectAtIndex:i];
        NSString *latitudeString = [[NSNumber numberWithDouble:currentPin.coordinate.latitude] stringValue];
        NSString *longitudeString = [[NSNumber numberWithDouble:currentPin.coordinate.longitude] stringValue];
//        //NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:latitudeString, @"latitude", longitudeString, @"longitude", @"", @"name", nil];
//        //NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:latitudeString, @"latitude", longitudeString, @"longitude", @"", @"name", nil];
        PFFile *pinTestPicture = [ItineraryPin getPFFileFromImage:[UIImage imageNamed:@"centralpark"]];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:latitudeString, @"latitude", longitudeString, @"longitude", pinTestPicture, @"pictureData", nil];
        [self.itineraryDraft.pinnedLocations addObject:dictionary];
    }
    [self addPathsToParse];

    
}

- (void)addPathsToParse{
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
//    [self.itineraryDraft saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//        if (error) {
//            NSLog(@"Error saving paths to Parse: %@", error);
//        }
//        else{
//            NSLog(@"Success saving paths to Parse");
//            [self performSegueWithIdentifier:@"doneSegue" sender:nil];
//        }
//    }];
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


@end
