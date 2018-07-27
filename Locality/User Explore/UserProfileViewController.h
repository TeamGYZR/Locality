//
//  UserProfileViewController.h
//  Locality
//
//  Created by Ginger Dudley on 7/26/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse.h"
#import "User.h"

@interface UserProfileViewController : UIViewController

@property (nonatomic, strong) User *user;

@end
