//
//  LCPathDetailViewController.h
//  Locality
//
//  Created by Youngmin Shin on 7/30/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Itinerary.h"
#import <Parse/Parse.h>

@interface LCPathDetailViewController : UIViewController

@property (strong, nonatomic) Itinerary *itinerary;

@end
