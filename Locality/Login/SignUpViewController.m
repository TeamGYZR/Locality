//
//  SignUpViewController.m
//  Locality
//
//  Created by Ginger Dudley on 7/23/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UITextField *accountNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) NSData *imageData;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;


@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)didTapUploadProfPicture:(id)sender {
    UIImagePickerController *imagePicker = [UIImagePickerController new];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else{
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePicker animated: YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info{
    UIImage *editedPicture = info[UIImagePickerControllerEditedImage];
    self.imageData = UIImagePNGRepresentation(editedPicture);
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    self.profilePicture.image = editedPicture;
    
}

- (IBAction)didTapSignup:(id)sender {
    User *newUser = [User user];
    newUser.username = self.usernameTextField.text;
    newUser.password = self.passwordTextField.text;
    newUser.email = self.emailTextField.text;
    newUser.name = self.accountNameTextField.text;
    newUser.following = [[NSMutableArray alloc] init];
    [newUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(error){
            NSLog(@"Failed to save following array %@", error.localizedDescription);
        } else {
            NSLog(@"success saving following array");
        }
    }];
    newUser.followers = [[NSMutableArray alloc] init];
    [newUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(error){
            NSLog(@"Failed to save followers array %@", error.localizedDescription);
        } else {
            NSLog(@"success saving follower array");
        }
    }];

    if (!self.imageData) {
        UIImage *defaultProfilePicture = [UIImage imageNamed:@"blankProfileimage"];
        self.imageData = UIImagePNGRepresentation(defaultProfilePicture);
    }
    newUser.profilePicture = [PFFile fileWithName:@"image.png" data:self.imageData];
    
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
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
            [self performSegueWithIdentifier:@"successfulSignup" sender:nil];
        }
    }];
}
- (IBAction)didTapCancel:(id)sender {
    [self performSegueWithIdentifier:@"cancelSegue" sender:nil];
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
