//
//  PlacesSearchTableViewController.m
//  Locality
//
//  Created by Youngmin Shin on 8/1/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "PlacesSearchTableViewController.h"
#import "PathCell.h"
#import "Itinerary.h"
#import "LCPathDetailViewController.h"
@interface PlacesSearchTableViewController ()

@end

@implementation PlacesSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PFQuery *query = [PFQuery queryWithClassName:@"Itinerary"];
    [query includeKey:@"path"];
    [query includeKey:@"creator"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *iteneraries, NSError *error){
        if (error) {
            NSLog(@"error loading paths from Parse");
        } else {
            self.itineraries = iteneraries;
            [self.tableView reloadData];
        }
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.matchingItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   PathCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PathCell" forIndexPath:indexPath];
    Itinerary * result = self.matchingItems[indexPath.row];
    cell.itinerary = result;
    cell.cellView.layer.cornerRadius = 20.0;
    cell.cellView.layer.borderWidth = 2.0;
    cell.cellView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.cellView.layer.masksToBounds = YES;
    return cell;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
    NSString *searchText = searchController.searchBar.text;
    if (searchText.length != 0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
            NSMutableArray * pins = evaluatedObject[@"pinnedLocations"];
            for(NSDictionary * pin in pins){
                if([pin[@"name"] containsString:searchText]){
                    return YES;
                }
            }
            return NO;
        }];
        self.matchingItems = [self.itineraries filteredArrayUsingPredicate:predicate];
    }
    else {
        self.matchingItems = nil;
    }
    [self.tableView reloadData];
    
};

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"searchToPath"]) {
        PathCell *tappedCell = sender;
        NSIndexPath * indexPath = [self.tableView indexPathForCell:tappedCell];
        Itinerary * detailItinerary = self.matchingItems[indexPath.row];
        UINavigationController *navigationController = [segue destinationViewController];
        LCPathDetailViewController *pathDetailsController = (LCPathDetailViewController*)navigationController.topViewController;
        pathDetailsController.itinerary = detailItinerary;
    }
}


@end
