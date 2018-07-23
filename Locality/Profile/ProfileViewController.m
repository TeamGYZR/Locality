//
//  ProfileViewController.m
//  Locality
//
//  Created by Ginger Dudley on 7/19/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "ProfileViewController.h"
#import "EditProfileViewController.h"
#import "ParseUI/ParseUI.h"
#import "APImanager.h"
#import "FavoriteCell.h"
#import "Favorite.h"
#import "AppDelegate.h"

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource, FavoriteCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet PFImageView *profiePicImageView;
@property (strong, nonatomic) NSArray * favorites;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) APIManager *apimanager;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [User currentUser];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    if (self.user.name == nil) {
        self.nameLabel.text = self.user.username;
    }
    else{
        self.nameLabel.text = self.user.name;
    }
    [self.nameLabel sizeToFit];
    if (self.user.profilePicture != nil) {
        self.profiePicImageView.file = self.user.profilePicture;
        [self.profiePicImageView loadInBackground];
    }
    
    self.apimanager = [APIManager new];
    [self loadFavorites];
}

- (IBAction)didTapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        ProfileViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        appDelegate.window.rootViewController = loginViewController;
    }];
}


-(void)loadFavorites{
    PFQuery *query = [PFQuery queryWithClassName:@"Favorite"];
    [query whereKey:@"user" equalTo: self.user];
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *favorites, NSError *error) {
        if ([favorites count] != 0) {
            // do something with the array of object returned by the call
            self.favorites = favorites;
            [self.tableView reloadData]; 
        } else {
            NSLog(@"Could not find any favorites - %@", error.localizedDescription);
        }
    }];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [self viewDidLoad];
}


-(NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section{
    return self.favorites.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FavoriteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FavoriteCell" forIndexPath:indexPath];
    
    
    Favorite * currentFavorite = self.favorites[indexPath.row];
    cell.delegate = self; 
    
    [self.apimanager fetchVenuewithVenueName:currentFavorite.venueName Latitude:currentFavorite.latitude Longitude:currentFavorite.longitude withCompletionHandler:^(Venue * venue, NSError * error){
        if(venue){
            NSLog(@"a favorite");
            cell.venue = venue;

            
        }
        else{
            NSLog(@"no favorites");
        }
        
        
    }];
    
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetectedSender:)];
//    singleTap.numberOfTapsRequired = 1;
//    [cell.profileView setUserInteractionEnabled:YES];
//    [cell.profileView addGestureRecognizer:singleTap];
    
    
    
    return cell;
    
    
    
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"editProfileSegue"]) {
        self.user = [User currentUser];
        EditProfileViewController *editProfViewController = segue.destinationViewController;
        editProfViewController.user = self.user;
    }
}


@end
