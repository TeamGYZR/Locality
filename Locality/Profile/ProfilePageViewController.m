//
//  ProfilePageViewController.m
//  Locality
//
//  Created by Ginger Dudley on 8/6/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "ProfilePageViewController.h"
#import "LCMapView.h"
#import "User.h"
#import "ParseUI/ParseUI.h"

@interface ProfilePageViewController ()


@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *fullName;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (nonatomic, strong) User *user;
@property (weak, nonatomic) IBOutlet LCMapView *lcMapView;
//@property (strong, nonatomic) NSArray *fa


@end

@implementation ProfilePageViewController

#pragma mark - View Controller
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"Profile"];
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(onTapLogout:)];
    [self.navigationItem setLeftBarButtonItem:logoutButton];
    self.user = [User currentUser];
    self.fullName.text = self.user.name;
    [self.fullName sizeToFit];
    self.userName.text = self.user.username;
    [self.userName sizeToFit];
    self.profilePicture.file = self.user.profilePicture;
    [self.profilePicture loadInBackground];
}

- (void)viewWillAppear:(BOOL)animated{
    [self queryForFavorites];
}

#pragma mark - Private Methods
- (void)queryForFavorites{
    PFQuery *query = [PFQuery queryWithClassName:@"PathFavorite"];
    [query whereKey:@"user" equalTo:PFUser.currentUser];
    [query includeKeys:@[@"user", @"itinerary"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable favorites, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error loading current user favorites");
        } else{
            [self.lcMapView configureWithFavoritedPaths:favorites];
        }
    }];
}

#pragma mark - IB Actions
- (void)onTapLogout:(UIBarButtonItem *)logoutButton{
    
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
