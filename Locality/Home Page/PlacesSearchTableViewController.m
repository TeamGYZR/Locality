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
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.matchingItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   PathCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PathCell" forIndexPath:indexPath];
    Itinerary * result = self.matchingItems[indexPath.row];
    cell.itinerary = result;
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
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


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
