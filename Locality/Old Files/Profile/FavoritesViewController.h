//
//  FavoritesViewController.h
//  Locality
//
//  Created by Youngmin Shin on 7/23/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "User.h"

@interface FavoritesViewController : UIViewController

@property (strong, nonatomic) User * user;
@end
