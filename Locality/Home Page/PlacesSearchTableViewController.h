//
//  PlacesSearchTableViewController.h
//  Locality
//
//  Created by Youngmin Shin on 8/1/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface PlacesSearchTableViewController : UITableViewController <UISearchResultsUpdating>
@property (strong, nonatomic) NSArray *matchingItems;
@property (strong, nonatomic) NSArray *itineraries;
@end
