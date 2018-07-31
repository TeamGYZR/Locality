//
//  PathDetailsViewController.m
//  Locality
//
//  Created by Youngmin Shin on 7/27/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "PathDetailsViewController.h"

@interface PathDetailsViewController ()<MKMapViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *pathNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *pathDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet PFImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
//@property (weak, nonatomic) IBOutlet LCMapView *lcMapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) NSMutableArray *pathCoordinates;
@property (nonatomic, retain) MKPolyline* polyline;
@property (strong, nonatomic) NSMutableArray *pinCoordinates;
@end

@implementation PathDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pathNameLabel.text = self.itinerary.name;
    self.pathDescriptionLabel.text = self.itinerary.pathDescription;
    self.userNameLabel.text = self.itinerary.creator.name; 
    if (self.itinerary.creator.profilePicture != nil) {
        self.userProfileImageView.file = self.itinerary.creator.profilePicture;
        [self.userProfileImageView loadInBackground];
    }
    //pinnedLocations is dictionary, pathCoordinates is CGPoints in Strings
    //[self.lcMapView initWithMap];
    //self.lcMapView.mapView.delegate = self;
    
    self.mapView.userInteractionEnabled = YES;
    self.mapView.zoomEnabled = NO;
    self.mapView.scrollEnabled = NO; 
    self.mapView.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.mapView.showsUserLocation = YES;
    [self.locationManager requestLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    self.currentLocation = [locations lastObject];
    //[self.pathCoordinates addObject:self.currentLocation];
    MKCoordinateRegion currentRegion = MKCoordinateRegionMake(self.currentLocation.coordinate, MKCoordinateSpanMake(0.025, 0.025));
    [self.mapView setRegion:currentRegion animated:YES];
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
        
        [self.mapView addOverlay:self.polyline];
        [self.mapView setNeedsDisplay];
    }
    
    NSUInteger numPins = [self.itinerary.pinnedLocations count];
    for(int i = 0; i< numPins; i++){
        MKPointAnnotation *annotation = [MKPointAnnotation new];
        annotation.coordinate = CLLocationCoordinate2DMake([self.itinerary.pinnedLocations[i][@"latitude"] doubleValue], [self.itinerary.pinnedLocations[i][@"longitude"] doubleValue]);
        annotation.title = @"Location";
        [self.mapView addAnnotation:annotation];
        
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"THERE WAS AN ERROR - %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error{
    NSLog(@"THERE WAS AN ERROR - %@", error);
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
