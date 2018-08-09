//
//  AddPinInfoView.m
//  Locality
//
//  Created by Zelalem Tenaw Terefe on 8/3/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "AddPinInfoView.h"
@implementation AddPinInfoView
- (instancetype)initWithFrame:(CGRect)frame{
  self=[super initWithFrame:frame];

    if(self){
        [self customnInt];
    }
    return self;
}
- (void)setDelegate:(id<AddPinInfoViewDelegate>)delegate{
      _delegate=delegate;
}
-(IBAction)didTapCameraButton:(id)sender{
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
    self.pinInfoCustomView.frame=self.bounds;
    [self addSubview:self.pinInfoCustomView];
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
    self.pinneddeditedPicture = info[UIImagePickerControllerEditedImage];
    UIViewController *yourCurrentViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (yourCurrentViewController.presentedViewController)
    {
        yourCurrentViewController = yourCurrentViewController.presentedViewController;
    }
    [yourCurrentViewController dismissViewControllerAnimated:YES completion:^{
        NSLog(@"dismmising");
    }];
    self.pinImageView.image=self.pinneddeditedPicture;
}
//- (void)didTappedCancel{
//    [self.delegate didTapViewCancel];
//}
- (IBAction)didTapCancel:(id)sender {
   [self.delegate didTapViewCancel];
}
- (IBAction)didTapShare:(id)sender {
    [self.delegate didTapViewShareWithImage:self.pinneddeditedPicture withName:self.pinNameField.text withDescription:self.pinDescriptionField.text];
}
- (IBAction)didTapUpperBlackBar:(id)sender {
    [self.pinNameField resignFirstResponder];
    [self.pinDescriptionField resignFirstResponder];
}

@end
