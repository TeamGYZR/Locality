//
//  CreateYourOwnViewController.h
//  Locality
//
//  Created by Ginger Dudley on 7/30/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddPinInfoView.h"

@interface CreateYourOwnViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UIButton *addPhoto;
@property (strong, nonatomic)  AddPinInfoView * addpininfoview;


@end
