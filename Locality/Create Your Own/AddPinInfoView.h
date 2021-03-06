//
//  AddPinInfoView.h
//  Locality
//
//  Created by Zelalem Tenaw Terefe on 8/3/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateYourOwnViewController.h"

@protocol AddPinInfoViewDelegate
-(void)didTapViewCancel;
-(void)didTapViewShareWithImage:(UIImage *)pinImage withName:(NSString *)pinName withDescription:(NSString *)pinDescription withCategory:(NSString *)category;
@end
@interface AddPinInfoView : UIView<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIView *pinInfoCustomView;
@property (weak, nonatomic) IBOutlet UITextField *pinNameField;
@property (weak, nonatomic) IBOutlet UITextView *pinDescriptionField;
@property (weak, nonatomic) IBOutlet UIImageView *pinImageView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (nonatomic,weak) id<AddPinInfoViewDelegate> delegate;
@property (strong, nonatomic) UIImage *pinneddeditedPicture;
@property (weak, nonatomic) IBOutlet UISegmentedControl *categorySegmentedControl;

-(void) customnInt;

@end
