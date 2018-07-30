//
//  PathDetailsViewController.m
//  Locality
//
//  Created by Youngmin Shin on 7/27/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "PathDetailsViewController.h"

@interface PathDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *pathNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *pathDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet PFImageView *userProfileImageView;

@end

@implementation PathDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pathNameLabel.text = self.itinerary.name;
    self.pathDescriptionLabel.text = self.itinerary.description;
    self.userNameLabel.text = self.itinerary.creator.name; 
    if (self.itinerary.creator.profilePicture != nil) {
        self.userProfileImageView.file = self.itinerary.creator.profilePicture;
        [self.userProfileImageView loadInBackground];
    }
    
    
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
