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
#import "AppDelegate.h"
#import "FavoritedPathCell.h"


@interface ProfilePageViewController () <UITableViewDelegate, UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *fullName;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (nonatomic, strong) User *user;
@property (weak, nonatomic) IBOutlet LCMapView *lcMapView;
@property (strong, nonatomic) NSArray *favoritedPaths;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) BOOL showFavorites;

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
    [self loadProfilePicture];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
    [self queryForFavorites];
    [self.tableView setFrame:CGRectMake(0, self.view.bounds.size.height, self.tableView.bounds.size.width, self.tableView.bounds.size.height)];
    self.showFavorites = NO;
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
            self.favoritedPaths = [[NSArray alloc] initWithArray:favorites];
            [self.lcMapView configureWithFavoritedPaths:favorites];
        }
    }];
}

- (void)loadProfilePicture{
    PFFile *imageFile = self.user.profilePicture;
    [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error retrieving profile picture data");
        } else {
            self.profilePicture.image = [UIImage imageWithData:data];
        }
    }];
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width / 2;
    self.profilePicture.clipsToBounds = YES;
}

#pragma mark - IB Actions
- (void)onTapLogout:(UIBarButtonItem *)logoutButton{
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        ProfilePageViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        appDelegate.window.rootViewController = loginViewController;
    }];
}

- (IBAction)didTapSavedPaths:(id)sender {
    if (self.showFavorites) {
        [UIView animateWithDuration:0.4 animations:^{
            [self.tableView setFrame:CGRectMake(0, self.view.bounds.size.height, self.tableView.bounds.size.width, self.tableView.bounds.size.height)];
            self.showFavorites = NO;
        }];
    } else{
        [self.tableView reloadData];
        [UIView animateWithDuration:0.4 animations:^{
            [self.tableView setFrame:CGRectMake(0, 432, 375, 235)];
        }];
        self.showFavorites = YES;
    }
}

#pragma mark - UITableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.favoritedPaths.count;
}
- (nonnull UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FavoritedPathCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FavoritedPathCell" forIndexPath:indexPath];
    cell.itinerary = self.favoritedPaths[indexPath.row][@"itinerary"];
    return cell;
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
