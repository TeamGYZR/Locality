//
//  LCMapView.m
//  Locality
//
//  Created by Youngmin Shin on 7/30/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "LCMapView.h"
#import "LCPathDetailViewController.h"
#import "pinVenueAnnotation.h"
#import "pinVenueAnnotationView.h"
#import "CLLocationManagerSingleton.h"

@interface LCMapView()<MKMapViewDelegate, CLLocationManagerDelegate>
@property (strong, nonatomic) NSArray *itineraries;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) MKPolyline *polyline;
@property (strong, nonatomic) NSMutableArray *favoritedPaths;
@property (nonatomic) BOOL testDirections;
@property (strong, nonatomic) CLCircularRegion *startRegion;
@property (strong, nonatomic) MKPolyline *directionPolyline;
@end

@implementation LCMapView {
    MKMapView *mapView;
    CLLocationManager *locationManager;
    BOOL isStatic;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        mapView.userInteractionEnabled = YES;
        return self;
    }
    return nil;
}

#pragma mark - Public Methods

-(void)configureWithItinerary:(Itinerary *)itinerary isStatic:(BOOL)move showCurrentLocation:(BOOL)showCurrent{
    mapView.delegate = self;
    //locationManager = [CLLocationManagerSingleton sharedSingleton].locationManager;
    locationManager = [CLLocationManager new];
    locationManager.delegate = self;
    isStatic = move;
    mapView.zoomEnabled = !isStatic;
    mapView.scrollEnabled = !isStatic;
    mapView.showsUserLocation = showCurrent;
    self.itineraries = @[itinerary];
    [self addSubview:mapView];
    self.testDirections = NO;
    [locationManager requestLocation];
}

- (void)configureWithFavoritedPaths:(NSArray *)favoritedPaths{
    mapView.delegate = self;
    locationManager = [CLLocationManager new];
    locationManager.delegate = self;
    [self addSubview:mapView];
    NSMutableArray *holderArray = [NSMutableArray new];
    for (int i = 0; i < [favoritedPaths count]; i++) {
        [holderArray addObject:favoritedPaths[i][@"itinerary"]];
    }
    self.itineraries = [holderArray copy];
    self.testDirections = NO;
    [locationManager requestLocation];
}

-(void)configureDirectionsWithItinerary:(Itinerary *)itinerary{
    self.itineraries = @[itinerary];
    mapView.delegate = self;
    locationManager = [CLLocationManager new];
    locationManager.delegate = self;
    [locationManager requestAlwaysAuthorization];
    mapView.showsUserLocation = YES;
    [mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    [self addSubview:mapView];
    [self getDirectionsForItinerary:itinerary];
}

-(void)drawMapWithArray{
    [locationManager requestLocation];
    
}

#pragma mark - Private Methods

-(void)drawPathForItinerary:(Itinerary *)itinerary{
    NSUInteger numPoints = [itinerary.paths count];
    if (numPoints > 1)
    {
        CLLocationCoordinate2D* coords = malloc(numPoints * sizeof(CLLocationCoordinate2D));
        for (int i = 0; i < numPoints; i++)
        {
            NSString* current = [itinerary.paths objectAtIndex:i];
            CGPoint currentPoint = CGPointFromString(current);
            coords[i] = CLLocationCoordinate2DMake(currentPoint.x, currentPoint.y);
        }
        self.polyline = [MKPolyline polylineWithCoordinates:coords count:numPoints];
        free(coords);
        
        [mapView addOverlay:self.polyline];
        [mapView setNeedsDisplay];
        
    }
    NSUInteger numPins = [itinerary.pinnedLocations count];
    self.pinsCount=numPins;
    for(int i = 0; i< numPins; i++){
        pinVenueAnnotation *pinAnnotation = [[pinVenueAnnotation alloc] initWithDictionary:itinerary.pinnedLocations[i]];
        [mapView addAnnotation:pinAnnotation];
     }
}

-(void)getDirectionsForItinerary:(Itinerary *)itinerary{
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = [MKMapItem mapItemForCurrentLocation];
    NSString* first = [itinerary.paths objectAtIndex:0];
    CGPoint firstPoint = CGPointFromString(first);
    CLLocationCoordinate2D destinationPoint = CLLocationCoordinate2DMake(firstPoint.x, firstPoint.y);
    MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:destinationPoint];
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
    request.destination = destination;
    request.transportType = MKDirectionsTransportTypeWalking;
    MKDirections *walkingDirections = [[MKDirections alloc] initWithRequest:request];
    self.testDirections = YES;
    [walkingDirections calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error){
        NSLog(@"%@", response.routes[0].description);
        self.directionPolyline = response.routes[0].polyline;
        [self setUpGeofenceForStartPoint:destinationPoint];
        [self->locationManager requestLocation];
    }];
    
}

-(void)setUpGeofenceForStartPoint:(CLLocationCoordinate2D)startCoordinate{
    self.startRegion = [[CLCircularRegion alloc]initWithCenter:startCoordinate radius:50.0 identifier:@"Start"];
    [mapView addOverlay:[MKCircle circleWithCenterCoordinate:startCoordinate radius:50.0]];
    [locationManager startMonitoringForRegion:self.startRegion];
}

#pragma mark - MapView delegate methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[pinVenueAnnotation class]]) {
        __block UIImageView * iconView = nil;
        pinVenueAnnotation *pinAnnotation = (pinVenueAnnotation *)annotation;
        pinVenueAnnotationView *annotationView = (pinVenueAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"PlacePin"];
        if (annotationView == nil) {
            annotationView = [[pinVenueAnnotationView alloc] initWithAnnotation:pinAnnotation reuseIdentifier:@"PlacePin"];
            [pinAnnotation.picture getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
                UIImage *tempholdImage=[UIImage imageWithData:data];
                iconView=[[UIImageView alloc] initWithImage:tempholdImage];
                annotationView.leftCalloutAccessoryView = iconView;
                annotationView.leftCalloutAccessoryView.frame= CGRectMake(0, 0, 50, 50);
                annotationView.leftCalloutAccessoryView.opaque=YES;
                annotationView.leftCalloutAccessoryView.userInteractionEnabled=YES;
            }];
            if ([pinAnnotation.pinCategory isEqualToString:@"Foodie"]) {
                annotationView.pinTintColor = [UIColor blueColor];
            } else if ([pinAnnotation.pinCategory isEqualToString:@"Entertainment"]){
                annotationView.pinTintColor = [UIColor redColor];
            } else if ([pinAnnotation.pinCategory isEqualToString:@"Nature"]){
                annotationView.pinTintColor = [UIColor grayColor];
            }
        }
        return annotationView;
    }
    return nil;
}
-(MKOverlayRenderer *)mapView:(MKMapView *)mapView
            rendererForOverlay:(id<MKOverlay>)overlay{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineRenderer *pathRenderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        if(self.testDirections){
            pathRenderer.fillColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
            pathRenderer.strokeColor = [[UIColor magentaColor] colorWithAlphaComponent:0.7];
        } else {
            pathRenderer.fillColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
            pathRenderer.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        }
        pathRenderer.lineWidth = 3;
        return pathRenderer;
    }
    if ([overlay isKindOfClass:[MKCircle class]]){
        MKCircleRenderer *circleRenderer = [[MKCircleRenderer alloc] initWithCircle:overlay];
        circleRenderer.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:0.5];
        circleRenderer.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        circleRenderer.lineWidth = 3;
        //circleRenderer.lineDashPhase = 2;
        return circleRenderer;
    }
    return nil;
}

#pragma  mark - CLLocationManager delegate methods
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    self.currentLocation = [locations lastObject];
    double numPaths = [self.itineraries count];
    if(numPaths == 1 && self.testDirections){
        Itinerary *itinerary = (Itinerary *)self.itineraries[0];
        MKCoordinateRegion currentRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude), MKCoordinateSpanMake(0.025, 0.025));
        [mapView setRegion:currentRegion animated:NO];
        if([self.startRegion containsCoordinate:self.currentLocation.coordinate]){
            [self.delegate userDidEnterStartRegion];
        } else{
            [mapView addOverlay:self.directionPolyline];
        }
        self.testDirections = NO;
        [self drawPathForItinerary:itinerary];
        [mapView setNeedsDisplay];
//        if(CLLocationManager.authorizationStatus != kCLAuthorizationStatusAuthorizedAlways){
//            [self.delegate userDeniedAlwaysLocation];
//        }
        return;
    }
    if (numPaths == 1) {
        Itinerary *itinerary = (Itinerary *)self.itineraries[0];
        NSString* center = [itinerary.paths objectAtIndex:(itinerary.paths.count/2)];
        CGPoint centerPoint = CGPointFromString(center);
        MKCoordinateRegion currentRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(centerPoint.x, centerPoint.y), MKCoordinateSpanMake(0.025, 0.025));
        [mapView setRegion:currentRegion animated:NO];
        [self drawPathForItinerary:itinerary];
    } else {
        MKCoordinateRegion currentRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude), MKCoordinateSpanMake(0.7, 0.7));
        [mapView setRegion:currentRegion animated:NO];
        for (int i = 0; i < [self.itineraries count]; i++) {
            Itinerary *itinerary = self.itineraries[i];
            [self drawPathForItinerary:itinerary];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"THERE WAS AN ERROR - %@", error.localizedDescription);
}

- (void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error{
    NSLog(@"THERE WAS AN ERROR - %@", error.localizedDescription);
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error{
    NSLog(@"GEOFENCING FAILED - %@", error.localizedDescription);
}
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    [mapView removeOverlay:self.directionPolyline];
    [self.delegate userDidEnterStartRegion];
}
- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region{
    NSLog(@"started monitoring for geofencing");
}


@end
