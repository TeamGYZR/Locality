//
//  Uploadphotoviewcontroller.m
//  Locality
//
//  Created by Zelalem Tenaw Terefe on 7/23/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "Uploadphotoviewcontroller.h"
#import "FlickrAuthorizationAppDelegate.h"
#import "AppDelegate.h"
NSString *kFetchRequestTokenStep = @"kFetchRequestTokenStep";
NSString *kStoredAuthTokenKeyName = @"FlickrOAuthToken";
NSString *kStoredAuthTokenSecretKeyName = @"FlickrOAuthTokenSecret";

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
    self.flickrRequest.sessionInfo = kFetchRequestTokenStep;
    [self.flickrRequest fetchOAuthRequestTokenWithCallbackURL:[NSURL URLWithString:SRCallbackURLBaseString]];

    /*
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else{
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
    */
}

//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
//    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
//   [self dismissViewControllerAnimated:YES completion:^{
//        NSInputStream *imageStream = [NSInputStream inputStreamWithData: UIImageJPEGRepresentation(originalImage, 0.9)];
//        BOOL check= [self->_flickrRequest uploadImageStream:imageStream suggestedFilename:@"Foobar.jpg" MIMEType:@"image/jpeg" arguments:[NSDictionary dictionaryWithObjectsAndKeys:@"1", @"is_public", nil]];
//        NSLog(@"Bool value: %d",check);
//    NSDictionary * uploaddic=[NSDictionary dictionaryWithObjectsAndKeys:self.Capikey,@"api_key ",nil];
//       [self->_flickrRequest callAPIMethodWithGET:@"flickr.people.getUploadStatus"  arguments:uploaddic];
//
//    }];
//
//}
- (OFFlickrAPIRequest *)flickrRequest
{
    if (!_flickrRequest) {
        _flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:self.flickrContext];
        _flickrRequest.delegate = self;
        _flickrRequest.requestTimeoutInterval = 60.0;
    }
    //[flickrapi sharedDelegate].flickrRequest=_flickrRequest;
    
    return _flickrRequest;
}
- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didObtainOAuthRequestToken:(NSString *)inRequestToken secret:(NSString *)inSecret
{
    // these two lines are important
    self.flickrContext.OAuthToken = inRequestToken;
    self.flickrContext.OAuthTokenSecret = inSecret;
    
    NSURL *authURL = [self.flickrContext userAuthorizationURLWithRequestToken:inRequestToken requestedPermission:OFFlickrWritePermission];
    [[UIApplication sharedApplication] openURL:authURL];
}
- (OFFlickrAPIContext *)flickrContext
{
    if (!_flickrContext) {
        _flickrContext = [[OFFlickrAPIContext alloc] initWithAPIKey:@"64578e39784b1c34163d4c53d924455b" sharedSecret:@"f14090263ea6b80c"];
        
        NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:kStoredAuthTokenKeyName];
        NSString *authTokenSecret = [[NSUserDefaults standardUserDefaults] objectForKey:kStoredAuthTokenSecretKeyName];
        
        if (([authToken length] > 0) && ([authTokenSecret length] > 0)) {
            _flickrContext.OAuthToken = authToken;
            _flickrContext.OAuthTokenSecret = authTokenSecret;
        }
    }
    return _flickrContext;
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
