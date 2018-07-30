//
//  LCMapView.m
//  Locality
//
//  Created by Youngmin Shin on 7/30/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "LCMapView.h"

@implementation LCMapView {
    MKMapView *mapView;
}

-(void)initWithMap{
    mapView.userInteractionEnabled = YES;
    mapView.zoomEnabled = NO;
    mapView.scrollEnabled = NO;
    [self addSubview:mapView];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
