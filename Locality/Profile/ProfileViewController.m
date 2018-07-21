//
//  ProfileViewController.m
//  Locality
//
//  Created by Ginger Dudley on 7/19/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "ProfileViewController.h"
#import "EditProfileViewController.h"
//instal parse ui pod to display images from PFFile
#import "ParseUI/ParseUI.h"
#import "APImanager.h"
#import "FavoriteCell.h"

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet PFImageView *profiePicImageView;
@property (strong, nonatomic) NSArray * favorites;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //setting the profile's user to the current user
    self.user = [User currentUser];
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
    [self loadFavorites];
}

-(void)loadFavorites{
    PFQuery *query = [PFQuery queryWithClassName:@"Favorite"];
    [query whereKey:@"user" equalTo: self.user];
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *favorites, NSError *error) {
        if ([favorites count] != 0) {
            // do something with the array of object returned by the call
            self.favorites = favorites;
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
    
     self.favorites[indexPath.row]
    cell.post = self.favorites[indexPath.row];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetectedSender:)];
    singleTap.numberOfTapsRequired = 1;
    [cell.profileView setUserInteractionEnabled:YES];
    [cell.profileView addGestureRecognizer:singleTap];
    
    
    
    return cell;
    
    
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    if ([segue.identifier isEqualToString:@"editProfileSegue"]) {
        self.user = [User currentUser];
        EditProfileViewController *editProfViewController = segue.destinationViewController;
        editProfViewController.user = self.user;
        
        
    }
    
    
    
}


@end
