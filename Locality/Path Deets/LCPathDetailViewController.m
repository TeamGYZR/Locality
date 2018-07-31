//
//  LCPathDetailViewController.m
//  Locality
//
//  Created by Youngmin Shin on 7/30/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "LCPathDetailViewController.h"
#import "LCMapView.h"

@interface LCPathDetailViewController ()
@property (weak, nonatomic) IBOutlet LCMapView *lcMapView;
@property (weak, nonatomic) IBOutlet UILabel *pathNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *pathDescriptionLabel;
@property (weak, nonatomic) IBOutlet PFImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@end

@implementation LCPathDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pathNameLabel.text = self.itinerary.name;
    self.pathDescriptionLabel.text = self.itinerary.pathDescription;
    self.userNameLabel.text = self.itinerary.creator.name;
    if (self.itinerary.creator.profilePicture != nil) {
        self.userProfileImageView.file = self.itinerary.creator.profilePicture;
        [self.userProfileImageView loadInBackground];
    }
    [self.lcMapView initWithItinerary:self.itinerary isStatic:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)mapViewType{
    return self;
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
