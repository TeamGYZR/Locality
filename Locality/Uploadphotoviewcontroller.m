//
//  Uploadphotoviewcontroller.m
//  Locality
//
//  Created by Zelalem Tenaw Terefe on 7/23/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "Uploadphotoviewcontroller.h"

@interface Uploadphotoviewcontroller ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation Uploadphotoviewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)whenuploadtap:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else{
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
    
}
-(void) setkey{
    self.Capikey=@"595a10deca33ce1b5a7ab291254fb22a";
    self.Csharedkey=@"cf18c4e987fb5146";
}
-(void) apimanager{
    self.cons= [[OFFlickrAPIContext alloc]
              initWithAPIKey:self.Capikey sharedSecret:self.Csharedkey];
    self.reqs=[[OFFlickrAPIRequest alloc] initWithAPIContext:self.cons];
    [self.reqs setDelegate:self];
   
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
   
    //self.image=originalImage;
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:^{
        NSInputStream *imageStream = [NSInputStream inputStreamWithData: UIImageJPEGRepresentation(originalImage, 0.9)];
       BOOL check= [self.reqs uploadImageStream:imageStream suggestedFilename:@"Foobar.jpg" MIMEType:@"image/jpeg" arguments:[NSDictionary dictionaryWithObjectsAndKeys:@"1", @"is_public", nil]];
        NSLog(@"Bool value: %d",check);
    NSDictionary * uploaddic=[NSDictionary dictionaryWithObjectsAndKeys:self.Capikey,@"api_key ",nil];
        [self.reqs callAPIMethodWithGET:@"flickr.people.getUploadStatus"  arguments:uploaddic];
        
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
