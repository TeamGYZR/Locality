//
//  AddPinInfoView.m
//  Locality
//
//  Created by Zelalem Tenaw Terefe on 8/3/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "AddPinInfoView.h"
//#import "CreateYourOwnViewController.h"
@implementation AddPinInfoView
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (instancetype)initWithFrame:(CGRect)frame{
  self=[super initWithFrame:frame];

    if(self){
        [self customnInt];
    }
    return self;
}
- (IBAction)didTapCameraButton:(id)sender{
    UIImagePickerController *imagePicker = [UIImagePickerController new];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else{
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    UIViewController *yourCurrentViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (yourCurrentViewController.presentedViewController)
    {
    yourCurrentViewController = yourCurrentViewController.presentedViewController;
    }
    [yourCurrentViewController presentViewController:imagePicker animated:YES completion:nil];
}
-(void) customnInt{
    [[NSBundle mainBundle] loadNibNamed:@"PinInfoView" owner:self options:nil];
    self.pinInfoCustomView.layer.shadowOffset=CGSizeZero;
    self.pinInfoCustomView.layer.shadowOpacity=0.8;
   [self addSubview:self.pinInfoCustomView];
    self.pinInfoCustomView.frame=self.bounds;
}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    for (UIView * view in [self subviews]) {
        if (view.userInteractionEnabled && [view pointInside:[self convertPoint:point toView:view] withEvent:event]) {
            return YES;
        }
    }
    return NO;
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *pinneddeditedPicture = info[UIImagePickerControllerEditedImage];
    UIViewController *yourCurrentViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (yourCurrentViewController.presentedViewController)
    {
        yourCurrentViewController = yourCurrentViewController.presentedViewController;
    }
    [yourCurrentViewController dismissViewControllerAnimated:YES completion:^{
        NSLog(@"dismmising");
    }];
    self.pinImageView.image=pinneddeditedPicture;
}
- (IBAction)didTapCancel:(id)sender{
    self.createPath=[[CreateYourOwnViewController alloc]init];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [self.pinInfoCustomView setAlpha:0.0];
   [self.createPath.viewOverMapView setAlpha:0.0]; //couldn't dimiss the view, help???
}
- (IBAction)didTapShare:(id)sender {
    

}



@end
