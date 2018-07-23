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
    [self registerUser];
    
}

- (IBAction)didTapLogin:(id)sender {
    [self loginUser];
}


-(void)registerUser{
    PFUser *newUser = [PFUser user];
    
    newUser.username = self.usernameTextField.text;
    newUser.password = self.passwordTextField.text;
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            //have an alert message display the localizedDescription
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error signing up!" message:(@"%@", error.localizedDescription) preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                      }];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:^{

            }];
            NSLog(@"error signing up User: %@", error.localizedDescription);
        }
        else{
            NSLog(@"User successfully registered!");
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}

-(void)loginUser{
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        if (error) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error logging in!" message:(@"%@", error.localizedDescription) preferredStyle:(UIAlertControllerStyleAlert)];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)usernameTextField:(id)sender {
}
@end
