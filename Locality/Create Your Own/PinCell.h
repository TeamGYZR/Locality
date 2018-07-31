//
//  PinCell.h
//  Locality
//
//  Created by Ginger Dudley on 7/31/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Itinerary.h"

@interface PinCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *pinNumberLabel;
@property (strong, nonatomic) Itinerary *itinerary;
//@property (nonatomic) NSInteger pinIndex;
@property (strong, nonatomic) NSNumber *pinIndex;
//@property (weak, nonatomic) NSDictionary *pinnedLocationDictionary;

@end
