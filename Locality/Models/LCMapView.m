//
//  LCMapView.m
//  Locality
//
//  Created by Youngmin Shin on 7/30/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "LCMapView.h"
#import "LCPathDetailViewController.h"

@interface LCMapView()<MKMapViewDelegate, CLLocationManagerDelegate>
@property (strong, nonatomic) Itinerary *itinerary;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) MKPolyline *polyline;
@end

@implementation LCMapView {
    MKMapView *mapView;
    CLLocationManager *locationManager;
}

-(void)initWithItinerary:(Itinerary *)itinerary isStatic:(BOOL)move{
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mapView.userInteractionEnabled = YES;
    mapView.delegate = self;
    mapView.zoomEnabled = !move;
    mapView.scrollEnabled = !move;
    mapView.showsUserLocation = !move;
    [self addSubview:mapView];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    self.itinerary = itinerary;
    [locationManager requestLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    self.currentLocation = [locations lastObject];
    NSString* center = [self.itinerary.paths objectAtIndex:(self.itinerary.paths.count/2)];
    CGPoint centerPoint = CGPointFromString(center);
    MKCoordinateRegion currentRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(centerPoint.x, centerPoint.y), MKCoordinateSpanMake(0.020, 0.020));
    [mapView setRegion:currentRegion animated:YES];
    [self drawPath];
}

-(void)drawPath{
    NSUInteger numPoints = [self.itinerary.paths count];
    if (numPoints > 1)
    {
        CLLocationCoordinate2D* coords = malloc(numPoints * sizeof(CLLocationCoordinate2D));
        for (int i = 0; i < numPoints; i++)
        {
            NSString* current = [self.itinerary.paths objectAtIndex:i];
            CGPoint currentPoint = CGPointFromString(current);
            coords[i] = CLLocationCoordinate2DMake(currentPoint.x, currentPoint.y);
        }
        self.polyline = [MKPolyline polylineWithCoordinates:coords count:numPoints];
        free(coords);
        
        [mapView addOverlay:self.polyline];
        [mapView setNeedsDisplay];
    }
    
    NSUInteger numPins = [self.itinerary.pinnedLocations count];
    for(int i = 0; i< numPins; i++){
        MKPointAnnotation *annotation = [MKPointAnnotation new];
        annotation.coordinate = CLLocationCoordinate2DMake([self.itinerary.pinnedLocations[i][@"latitude"] doubleValue], [self.itinerary.pinnedLocations[i][@"longitude"] doubleValue]);
        annotation.title = @"Location";
        [mapView addAnnotation:annotation];
    }
    
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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
