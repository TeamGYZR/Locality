//
//  VerificationSignUpViewController.m
//  Locality
//
//  Created by Youngmin Shin on 7/27/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "VerificationSignUpViewController.h"
#import "DetailSignUpViewController.h"
#import "User.h"

@interface VerificationSignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) User *currentUser;
@end

@implementation VerificationSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapNext:(id)sender
{
    self.currentUser = [User user];
    self.currentUser.username = self.usernameField.text;
    self.currentUser.password = self.passwordField.text;
    
    
    [self.currentUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error signing up!" message:error.localizedDescription preferredStyle:(UIAlertControllerStyleAlert)];
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
            [self performSegueWithIdentifier:@"successfulSignup" sender:nil];
        }
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [[self view] endEditing:TRUE];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller
    if([segue.identifier isEqualToString:@"successfulSignup"]){
        DetailSignUpViewController * detailSignUpViewController =[segue destinationViewController];
        detailSignUpViewController.currentUser = self.currentUser;
        
    }
}


@end
