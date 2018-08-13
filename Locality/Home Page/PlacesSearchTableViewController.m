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
@interface PlacesSearchTableViewController ()<UITableViewDataSource, UITableViewDataSource>
@property (strong, nonatomic) UISearchController * customSearchBar;
@end

@implementation PlacesSearchTableViewController
-(void)viewDidLoad {
    [super viewDidLoad];
    self.autoCompleteTableView.separatorColor=[UIColor clearColor];
      self.tableView.separatorColor=[UIColor clearColor];
        self.autoCompleteTableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
 self.autoCompleteTableView.userInteractionEnabled=YES;
    [self.autoCompleteView sizeToFit];
    //self.autoCompleteView.s
    if(self.tableView.isDragging && self.tableView.isDecelerating){
        //self.autoCompleteView.
    }
    
    
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
-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView==self.autoCompleteTableView){
        [UIView animateWithDuration:100
                         animations:^{
                             self.autoCompleteView.hidden=NO;
                           [self.autoCompleteView sizeToFit];
                             }];
        return self.listOfTemArray.count;
    }
    return self.matchingItems.count;
   
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * autoCell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!autoCell){
        autoCell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        autoCell.layer.masksToBounds=YES;
    }
    if(tableView==self.autoCompleteTableView){
        autoCell.textLabel.text=[NSString stringWithFormat:self.listOfTemArray[indexPath.row], indexPath.row];
        
      return autoCell;
        
    }else{
    PathCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PathCell" forIndexPath:indexPath];
        Itinerary * result = self.matchingItems[indexPath.row];
        cell.itinerary = result;
        cell.cellView.layer.cornerRadius = 20.0;
        cell.cellView.layer.borderWidth = 2.0;
        cell.cellView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cell.cellView.layer.masksToBounds = YES;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.customSearchBar.searchBar.text=[NSString stringWithFormat:self.listOfTemArray[indexPath.row], indexPath.row];
    
}
-(void) dismissView{
  self.autoCompleteView.hidden=YES;
}
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
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
    if(self.listOfTemArray!= nil){
    
  [self.autoCompleteTableView reloadData];
        [self.tableView reloadData];
    }else{
      [self.tableView reloadData];
    }
 
}
#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)];
//    [self.tableView addGestureRecognizer:tap];
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
