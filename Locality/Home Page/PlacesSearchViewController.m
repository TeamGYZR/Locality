//
//  PlacesSearchViewController.m
//  Locality
//
//  Created by Zelalem Tenaw Terefe on 8/13/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "PlacesSearchViewController.h"
#import "PathCell.h"
#import "Itinerary.h"
#import "LCPathDetailViewController.h"

@interface PlacesSearchViewController ()<UITableViewDataSource, UITableViewDataSource>
@property (strong, nonatomic) UISearchController * customSearchBar;
@end

@implementation PlacesSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight=311;
    self.tableView.separatorColor=[UIColor clearColor];
   PFQuery *query = [PFQuery queryWithClassName:@"Itinerary"];
    [query includeKey:@"path"];
    [query includeKey:@"creator"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *itineraries, NSError *error){
        if (error) {
            NSLog(@"error loading paths from Parse");
        } else {
            self.itineraries = itineraries;
            [self.tableView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   if(self.segmentedControl.selectedSegmentIndex==0){
       return self.matchingItems.count;
   }else{
      return self.listOfTemArray.count;
  }
   
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * autoCell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
   if(!autoCell){
        autoCell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
     }
    if(self.segmentedControl.selectedSegmentIndex==1){
        autoCell.textLabel.text=[NSString stringWithFormat:self.listOfTemArray[indexPath.row], indexPath.row];
        self.tableView.rowHeight=30;
    return autoCell;

    }else{
        PathCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PathCell" forIndexPath:indexPath];
        Itinerary * result = self.matchingItems[indexPath.row];
        self.tableView.rowHeight=311;
        cell.itinerary = result;
        cell.cellView.layer.cornerRadius = 20.0;
        cell.cellView.layer.borderWidth = 2.0;
        cell.cellView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cell.cellView.layer.masksToBounds = YES;
        return cell;
  }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row<self.listOfTemArray.count){
    self.customSearchBar.searchBar.text=[NSString stringWithFormat:self.listOfTemArray[indexPath.row], indexPath.row];
        self.segmentedControl.selectedSegmentIndex = 0;
        [self.segmentedControl sendActionsForControlEvents:UIControlEventValueChanged];
    }

}
-(void) dismissView{
    self.autoCompleteView.hidden=YES;
}
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
        self.segmentedControl.selectedSegmentIndex=1;
    self.customSearchBar=searchController;
    NSString *searchText = searchController.searchBar.text;
    __block NSString * name=nil;
    __block NSString *firstLetter=nil;
    __block NSMutableArray *itemsOfMainArray=[[NSMutableArray alloc] init];
    self.listOfTemArray=[[NSMutableArray alloc]init];
    if (searchText.length != 0) {
        NSPredicate *predicate =[NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
            NSMutableArray * pins = evaluatedObject[@"pinnedLocations"];
            itemsOfMainArray=pins;
            for(int i=0; i<itemsOfMainArray.count; i++){
                name=itemsOfMainArray[i][@"name"];
                if (name.length >= searchText.length)
                {
                    firstLetter = [name substringWithRange:NSMakeRange(0, [searchText length])];
                    if( [firstLetter caseInsensitiveCompare:searchText] == NSOrderedSame )
                    {
                        [self.listOfTemArray addObject:itemsOfMainArray[i][@"name"]];
                        NSLog(@"=========> %@",self.listOfTemArray);
                    }
                }
                
            }
            NSArray * temporaryArray=[self.listOfTemArray copy];
            NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:temporaryArray];
             temporaryArray=[orderedSet array];
            self.listOfTemArray=[NSMutableArray arrayWithArray:temporaryArray];
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
        self.listOfTemArray=nil;
        self.matchingItems = nil;
    }
[self.tableView reloadData];
}
#pragma mark - IBActions

- (IBAction)searchSegement:(id)sender {
    [self.tableView reloadData];
    
}
#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
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
