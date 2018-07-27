//
//  DetailSignUpViewController.m
//  Locality
//
//  Created by Youngmin Shin on 7/27/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "DetailSignUpViewController.h"
#import "User.h"

@interface DetailSignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountNameField;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (strong, nonatomic) NSData *imageData;


@end

@implementation DetailSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapUploadProfileImage:(id)sender {
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
        self.profilePicture.image = editedPicture;
    }];

    
}
- (IBAction)didTapGo:(id)sender {
    if (!self.imageData) {
        UIImage *defaultProfilePicture = [UIImage imageNamed:@"blankProfileimage"];
        self.imageData = UIImagePNGRepresentation(defaultProfilePicture);
    }
    self.currentUser.profilePicture = [PFFile fileWithName:@"image.png" data:self.imageData];
    self.currentUser.name = self.accountNameField.text;
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            [self performSegueWithIdentifier:@"segueToCategories" sender:nil];
        }
        else if (error){
            NSLog(@"Could not save user error-%@", error.localizedDescription);
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

@end
