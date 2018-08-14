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
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    locationManager.distanceFilter = 10;
    isStatic = move;
    mapView.zoomEnabled = !isStatic;
    mapView.scrollEnabled = !isStatic;
    mapView.showsUserLocation = showCurrent;
    self.itineraries = @[itinerary];
    [self addSubview:mapView];
    self.testDirections = NO;
    [locationManager startUpdatingLocation];
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
    NSString *first = [itinerary.paths objectAtIndex:0];
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
        [self setUpGeofenceForStartPoint:destinationPoint AndItinerary:itinerary];
        [self->locationManager requestLocation];
    }];
    
}

-(void)setUpGeofenceForStartPoint:(CLLocationCoordinate2D)startCoordinate AndItinerary:(Itinerary *)itinerary {
    self.startRegion = [[CLCircularRegion alloc]initWithCenter:startCoordinate radius:20.0 identifier:@"Start"];
    [locationManager startMonitoringForRegion:self.startRegion];
    for(int i = 0; i < [itinerary.pinnedLocations count]; i++){
        NSDictionary *current = [itinerary.pinnedLocations objectAtIndex:i];
        CLLocationCoordinate2D currentPoint = CLLocationCoordinate2DMake([current[@"latitude"] doubleValue], [current[@"longitude"] doubleValue]);
       CLCircularRegion *pinRegion = [[CLCircularRegion alloc] initWithCenter:currentPoint radius:30.0 identifier:@"pinRegion"];
        [locationManager startMonitoringForRegion:pinRegion];
    }
    
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
                
                CGSize size = CGSizeMake(150, 150);
                UIGraphicsBeginImageContext(size);
                [tempholdImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
                UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
                
                iconView=[[UIImageView alloc] initWithImage:resizedImage];
//                annotationView.leftCalloutAccessoryView = iconView;
//                annotationView.leftCalloutAccessoryView.frame= CGRectMake(0, 0, 50, 50);
//                annotationView.leftCalloutAccessoryView.opaque=YES;
//                annotationView.leftCalloutAccessoryView.userInteractionEnabled=YES;
                iconView.frame = CGRectMake(0, 0, 150, 150);
                annotationView.detailCalloutAccessoryView = iconView;
                annotationView.detailCalloutAccessoryView.opaque=YES;
                annotationView.detailCalloutAccessoryView.userInteractionEnabled=YES;
                annotationView.image = [UIImage imageNamed:@"dummy_annotation"];
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
            pathRenderer.fillColor = [[UIColor colorWithRed:.9254 green:.41176 blue:.30196 alpha:1] colorWithAlphaComponent:0.2];
            pathRenderer.strokeColor = [[UIColor colorWithRed:.9254 green:.41176 blue:.30196 alpha:1] colorWithAlphaComponent:0.7];
        } else {
            pathRenderer.fillColor = [[UIColor colorWithRed:0.6 green:0.796 blue:0.9686 alpha:1.0] colorWithAlphaComponent:0.2];
            pathRenderer.strokeColor = [[UIColor colorWithRed:.1843 green:.28235 blue:.34509 alpha:1] colorWithAlphaComponent:0.7];
        }
        pathRenderer.lineWidth = 2;
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
//        MKCoordinateRegion currentRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude), MKCoordinateSpanMake(0.025, 0.025));
//        [mapView setRegion:currentRegion animated:NO];
        if([self.startRegion containsCoordinate:self.currentLocation.coordinate]){
            [self.delegate userDidEnterStartRegion];
        } else{
            [mapView addOverlay:self.directionPolyline];
        }
        self.testDirections = NO;
        [self drawPathForItinerary:itinerary];
        [mapView setNeedsDisplay];
        [mapView setVisibleMapRect:[self.directionPolyline boundingMapRect] edgePadding:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0) animated:NO];
        return;
    }
    if (numPaths == 1) {
        Itinerary *itinerary = (Itinerary *)self.itineraries[0];
        [self drawPathForItinerary:itinerary];
        [mapView setVisibleMapRect:[self.polyline boundingMapRect] edgePadding:UIEdgeInsetsMake(300.0, 50.0, 50.0, 50.0) animated:NO];
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
    if([region.identifier isEqualToString:@"Start"]){
        [mapView removeOverlay:self.directionPolyline];
        [self.delegate userDidEnterStartRegion];
    }
}
- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region{
    NSLog(@"started monitoring for geofencing");
}


@end
