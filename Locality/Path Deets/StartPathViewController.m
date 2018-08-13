//
//  StartPathViewController.m
//  Locality
//
//  Created by Youngmin Shin on 8/7/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "StartPathViewController.h"
#import "LCMapView.h"

@interface StartPathViewController () <LCMapViewDelegate>
@property (strong, nonatomic) IBOutlet LCMapView *mapView;
@property (strong, nonatomic) IBOutlet UILabel *commandTextField;
@property (weak, nonatomic) IBOutlet UIView *enteredPathView;

@end

@implementation StartPathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.mapView configureDirectionsWithItinerary:self.itinerary];
    self.mapView.delegate = self;
    [self.enteredPathView setFrame:CGRectMake(0, self.view.bounds.size.height, self.enteredPathView.bounds.size.width, self.enteredPathView.bounds.size.height)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)userDidEnterStartRegion{
    NSLog(@"user is on the path");
    [UIView animateWithDuration:0.4 animations:^{
        [self.enteredPathView setFrame:CGRectMake(0, 522, 375, 145)];
    }];
}

- (void)userDeniedAlwaysLocation{
    [self dismissViewControllerAnimated:YES completion:nil];
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
