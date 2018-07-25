//
//  DetailsViewController.h
//  Locality
//
//  Created by Ginger Dudley on 7/17/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Venue.h"
#import "Favorite.h"
#import "ReviewViewController.h"
//#import "Speech"
#import <AVFoundation/AVFoundation.h>
@interface DetailsViewController : UIViewController


@property AVSpeechSynthesizer* speech;

//@property Venue *venue;
@property (strong, nonatomic) Venue *venue;

@end
