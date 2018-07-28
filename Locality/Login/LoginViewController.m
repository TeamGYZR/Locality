//
//  LoginViewController.m
//  Locality
//
//  Created by Ginger Dudley on 7/18/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "LoginViewController.h"
#import "Parse.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "PFFacebookUtils.h"
#import "SignUpViewController.h"
#import "VerificationSignUpViewController.h"
#import "HomeViewController.h"
#import <CoreLocation/CoreLocation.h>


@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *facebookLoginButton;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.facebookLoginButton sizeToFit];
}

- (IBAction)didTapSignUp:(id)sender {
    [self performSegueWithIdentifier:@"signUpSegue" sender:nil];
    
}

- (IBAction)didTapLogin:(id)sender {
    [self loginUser];
}


-(void)loginUser{
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        if (error) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error logging in!" message:error.localizedDescription preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                      }];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:^{

            }];
            NSLog(@"error logging in user: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully signed in user!");
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
    
}

-(void)loginWithFacebook{
    
    NSArray *permissions = [NSArray arrayWithObjects:@"email", @"public_profile", nil];
    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissions block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        } else {
            NSLog(@"User logged in through Facebook!");
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"loginSegue"]){
        UINavigationController *navigationController = [segue destinationViewController];
        HomeViewController *homeController = (HomeViewController*)navigationController.topViewController;
        homeController.currentLocation = CLLocationCoordinate2DMake(self.lat, self.lon); 
    }
    if([[segue identifier] isEqualToString:@"signUpSegue"]){
        VerificationSignUpViewController *signUpViewController =[segue destinationViewController];
        signUpViewController.lat = self.lat;
        signUpViewController.lon = self.lon;
    }
}


- (IBAction)usernameTextField:(id)sender {
}
@end
