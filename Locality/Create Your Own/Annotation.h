//
//  Annotation.h
//  Locality
//
//  Created by Zelalem Tenaw Terefe on 8/8/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
//#import <MapKit/MKAnnotation.h>
//#import <MapKit/MKAnnotationView.h>
//#import <MapKit/MKPinAnnotationView.h>

@interface Annotation : NSObject<MKAnnotation>{
    CLLocationCoordinate2D coordinate;
    
}

@end
