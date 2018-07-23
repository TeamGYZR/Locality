//
//  EditProfileViewController.m
//  Locality
//
//  Created by Ginger Dudley on 7/19/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "EditProfileViewController.h"
#import "ParseUI/ParseUI.h"

@interface EditProfileViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *editedProfilePicture;


@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)didTapSave:(id)sender {
    
    if ([self.nameTextField.text isEqualToString:@""]) {
        //dont change the users name
    }
    else{
        self.user.name = self.nameTextField.text;
    }
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
       //save user's data to parse
    }];
    
}

//letting user add profile picture
- (IBAction)didTapPicEdit:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else{
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    NSData *imageData = UIImagePNGRepresentation(editedImage);
    self.user.profilePicture = [PFFile fileWithName:@"image.png" data:imageData];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    self.editedProfilePicture.image = editedImage;
    
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
