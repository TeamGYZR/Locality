//
//  PinCell.h
//  Locality
//
//  Created by Ginger Dudley on 7/31/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Itinerary.h"
#import "PathFinalizationViewController.h"

@protocol PinCellDelegate

- (void)textNameDidChange:(id)passedCell;
//animating screen once text field is tapped
- (void)userTappedTextField;

@end

@interface PinCell : UITableViewCell 

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *pinNumberLabel;
@property (strong, nonatomic) Itinerary *itinerary;
@property (strong, nonatomic) NSNumber *pinIndex;
@property (strong, nonatomic) NSString *nameChange;

@property(weak, nonatomic) id<UITextFieldDelegate> delegate;
@property (weak, nonatomic)id<PinCellDelegate> pinDelegate;

@end
