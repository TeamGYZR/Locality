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

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet PFImageView *profiePicImageView;

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [self viewDidLoad];
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
