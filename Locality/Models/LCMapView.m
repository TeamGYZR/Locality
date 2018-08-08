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
@property (strong, nonatomic) Itinerary *itinerary;
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
        return self;
    }
    return nil;
}

#pragma mark - Public Methods

-(void)configureWithItinerary:(Itinerary *)itinerary isStatic:(BOOL)move showCurrentLocation:(BOOL)showCurrent{
    //move
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mapView.userInteractionEnabled = YES;
    mapView.delegate = self;
    //keep
    isStatic = move;
    mapView.zoomEnabled = !isStatic;
    mapView.scrollEnabled = !isStatic;
    mapView.showsUserLocation = showCurrent;
    locationManager = [CLLocationManagerSingleton sharedSingleton].locationManager;
    locationManager.delegate = self;
    self.itinerary = itinerary;
    //move
    [self addSubview:mapView];
    //stay w location manager
    [locationManager requestLocation];
}

- (void)configureWithFavoritedPaths:(NSArray<Itinerary *> *)favoritedPaths{
    self.favoritedPaths = [[NSMutableArray alloc] init];
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mapView.userInteractionEnabled = YES;
    mapView.delegate = self;
    mapView.zoomEnabled = YES;
    mapView.scrollEnabled = YES;
    mapView.showsUserLocation = YES;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [self addSubview:mapView];
    [locationManager requestLocation];
    for (int i = 0; i < [favoritedPaths count]; i++) {
        [self.favoritedPaths addObject:favoritedPaths[i][@"itinerary"]];
    }
    
}

#pragma mark - Private Methods
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    self.currentLocation = [locations lastObject];
    if (self.itinerary) {
        NSString* center = [self.itinerary.paths objectAtIndex:(self.itinerary.paths.count/2)];
        CGPoint centerPoint = CGPointFromString(center);
        MKCoordinateRegion currentRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(centerPoint.x, centerPoint.y), MKCoordinateSpanMake(0.025, 0.025));
        [mapView setRegion:currentRegion animated:NO];
    } else {
        MKCoordinateRegion currentRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude), MKCoordinateSpanMake(0.7, 0.7));
        [mapView setRegion:currentRegion animated:NO];
    }
    if (!self.favoritedPaths) {
        [self drawPathForItinerary:self.itinerary];
    } else{
        for (int i = 0; i < [self.favoritedPaths count]; i++) {
            Itinerary *itinerary = self.favoritedPaths[i];
            [self drawPathForItinerary:itinerary];
        }
    }
}

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
    for(int i = 0; i< numPins; i++){
        pinVenueAnnotation *pinAnnotation = [[pinVenueAnnotation alloc] initWithDictionary:itinerary.pinnedLocations[i]];
        [mapView addAnnotation:pinAnnotation];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[pinVenueAnnotation class]]) {
        pinVenueAnnotationView *annotationView = (pinVenueAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"PlacePin"];
        if (annotationView == nil) {
            annotationView = [[pinVenueAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"PlacePin"];
            annotationView.canShowCallout = true;
        }
        return annotationView;
    }
    return nil;
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


@end
