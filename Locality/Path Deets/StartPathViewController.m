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
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIView *confettiView;

@end

@implementation StartPathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.mapView configureDirectionsWithItinerary:self.itinerary];
    self.mapView.delegate = self;
    self.confettiView.frame = CGRectMake(0, -530, 375, 490);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)userDidEnterStartRegion{
    self.commandTextField.text = @"You are at the start of the path!";
    self.iconImageView.image = [UIImage imageNamed:@"confettiIcon"];
    [UIView animateWithDuration:3.5 animations:^{
        [self.confettiView setFrame:CGRectMake(0, 177, 375, 490)];
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
