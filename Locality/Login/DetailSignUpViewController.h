//
//  DetailSignUpViewController.h
//  Locality
//
//  Created by Youngmin Shin on 7/27/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
@interface DetailSignUpViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) User *currentUser; 
@property (nonatomic) double lat;
@property (nonatomic) double lon;
@end
