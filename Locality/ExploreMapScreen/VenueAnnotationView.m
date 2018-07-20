//
//  VenueAnnotationView.m
//  Locality
//
//  Created by Youngmin Shin on 7/17/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "VenueAnnotationView.h"

@implementation VenueAnnotationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if(self){
        self.enabled = YES;
        self.canShowCallout = true;
        
        //        //annotationView.frame = CGRectMake(0.0, 0.0, 200.0, 200.0);
        //        //annotationView.detailCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 200.0)];
        self.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)];
       self.rightCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)];
    }
    
    return self;
}

//-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
//    MKPinAnnotationView * annotationView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
//
//    if(annotationView == nil){
//
//        annotationView =[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
//        annotationView.canShowCallout = true;
//        annotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)];
//        annotationView.rightCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)];
//    }
//
//    UIImageView *imageView = (UIImageView*)annotationView.leftCalloutAccessoryView;
//    imageView.image = [UIImage imageNamed:@"frenchfries"];
//
//    UIButton *collectionButton = [UIButton buttonWithType:UIButtonTypeSystem];
//
//    //[collectionButton addTarget:self action:@selector(goToCollection:) forControlEvents:UIControlEventTouchUpInside];
//    [collectionButton setTitle:@"Next" forState:UIControlStateNormal];
//    collectionButton.frame = CGRectMake(0.0, 0.0, 50.0, 50.0);
//    [collectionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//
//
//    //[annotationView.rightCalloutAccessoryView addSubview:collectionButton];
//    [annotationView.rightCalloutAccessoryView setUserInteractionEnabled:YES];
//    annotationView.rightCalloutAccessoryView = collectionButton;
//
//    return annotationView;
//
//}

@end
