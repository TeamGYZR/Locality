//
//  DetailsCollectionViewController.h
//  Locality
//
//  Created by Ginger Dudley on 7/24/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Venue.h"
#import "Favorite.h"
#import "ReviewViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface DetailsCollectionViewController : UIViewController

@property AVSpeechSynthesizer *speech;
@property (strong, nonatomic) Venue *venue;

@end
