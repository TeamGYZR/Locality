//
//  ResultsTableViewController.h
//  Locality
//
//  Created by Youngmin Shin on 7/23/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ResultsTableViewController : UITableViewController <UISearchResultsUpdating>

@property (nonatomic) CLLocationCoordinate2D currentLocation;
@property (strong, nonatomic) NSArray * matchingItems;
@end
