//
//  AddPinInfoView.h
//  Locality
//
//  Created by Zelalem Tenaw Terefe on 8/3/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateYourOwnViewController.h"

@interface AddPinInfoView : UIView<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIView *pinInfoCustomView;
@property (weak, nonatomic) IBOutlet UITextField *pinNameField;
@property (weak, nonatomic) IBOutlet UITextField *pinDescriptionField;
@property (weak, nonatomic) IBOutlet UIImageView *pinImageView;
@property (strong, nonatomic) UIViewController * controller;
@property (strong, nonatomic)  CreateYourOwnViewController * createPath;
-(void) customnInt;

@end
