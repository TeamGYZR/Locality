//
//  PlacesSearchViewController.h
//  Locality
//
//  Created by Zelalem Tenaw Terefe on 8/13/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface PlacesSearchViewController : UIViewController <UISearchResultsUpdating>
@property (strong, nonatomic) NSArray *matchingItems;
@property (strong, nonatomic) NSArray *itineraries;
@property (strong, nonatomic)  NSMutableArray *listOfTemArray;
@property (weak, nonatomic) IBOutlet UITableView *autoCompleteTableView;
@property (weak, nonatomic) IBOutlet UIView *autoCompleteView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@end
