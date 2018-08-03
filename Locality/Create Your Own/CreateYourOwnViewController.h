//
//  CreateYourOwnViewController.h
//  Locality
//
//  Created by Ginger Dudley on 7/30/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateYourOwnViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UIButton *addPhoto;

@end
