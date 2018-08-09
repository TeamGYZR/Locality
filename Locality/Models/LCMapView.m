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
    [locationManager requestLocation];
}

//- (void)configureWithFavoritedPaths:(NSArray<Itinerary *> *)favoritedPaths{
//    self.favoritedPaths = [[NSMutableArray alloc] init];
//    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    mapView.userInteractionEnabled = YES;
//    mapView.delegate = self;
//    mapView.zoomEnabled = YES;
//    mapView.scrollEnabled = YES;
//    mapView.showsUserLocation = YES;
//    locationManager = [[CLLocationManager alloc] init];
//    locationManager.delegate = self;
//    [self addSubview:mapView];
//    //[self drawMapWithArray];
//    [locationManager requestLocation];
////    for (int i = 0; i < [favoritedPaths count]; i++) {
////        [self.favoritedPaths addObject:favoritedPaths[i][@"itinerary"]];
////    }
//
//}

-(void)testDirectionsWithItinerary:(Itinerary *)itinerary{
    self.itineraries = @[itinerary];
    [self addSubview:mapView];
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    //request.source = self.currentLocation;
    [self drawMapWithArray];
}

-(void)drawMapWithArray{
    [locationManager requestLocation];
    
}

#pragma mark - Private Methods
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    self.currentLocation = [locations lastObject];
    double numPaths = [self.itineraries count];
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
-(void)drawPathForItinerary:(Itinerary *)itinerary{
    self.myItinerary=[[Itinerary alloc]init];
    self.myItinerary=itinerary;
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
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[pinVenueAnnotation class]]) {
         PFFile *eventImage=nil;
        __block UIImageView * iconView=nil;
        NSString * string=annotation.title;
        pinVenueAnnotationView *annotationView = (pinVenueAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"PlacePin"];
        if (annotationView == nil) {
            annotationView = [[pinVenueAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"PlacePin"];
            for(int i=0; i<self.pinsCount; i++){
                if([string isEqualToString:self.myItinerary.pinnedLocations[i][@"name"]]){
                   eventImage=self.myItinerary.pinnedLocations[i][@"pictureData"];
                    [eventImage getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
                        UIImage *tempholdImage=[UIImage imageWithData:data];
                        iconView=[[UIImageView alloc] initWithImage:tempholdImage];
                        annotationView.leftCalloutAccessoryView = iconView;
                        annotationView.leftCalloutAccessoryView.frame= CGRectMake(0, 0, 50, 50);
                        annotationView.leftCalloutAccessoryView.opaque=YES;
                        annotationView.leftCalloutAccessoryView.userInteractionEnabled=YES;
                        annotationView.canShowCallout = YES;
                    }];
                }
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
        pathRenderer.fillColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
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


@end
