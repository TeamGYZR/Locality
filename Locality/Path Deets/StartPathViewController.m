//
//  StartPathViewController.m
//  Locality
//
//  Created by Youngmin Shin on 8/7/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "StartPathViewController.h"
#import "LCMapView.h"

@interface StartPathViewController ()
@property (strong, nonatomic) IBOutlet LCMapView *mapView;

@end

@implementation StartPathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.mapView directionsWithItinerary:self.itinerary];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
