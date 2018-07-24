//
//  FavoritesViewController.m
//  Locality
//
//  Created by Youngmin Shin on 7/23/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "FavoritesViewController.h"
#import "APImanager.h"
#import "FavoriteCell.h"

@interface FavoritesViewController () <UITableViewDelegate, UITableViewDataSource, FavoriteCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) APIManager * apimanager;
@property (strong, nonatomic) NSArray * favorites;
@end

@implementation FavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.user = [User currentUser];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.apimanager = [APIManager new];
    [self loadFavorites];
}

-(void)loadFavorites{
    PFQuery *query = [PFQuery queryWithClassName:@"Favorite"];
    [query whereKey:@"user" equalTo: self.user];
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *favorites, NSError *error) {
        if ([favorites count] != 0) {
            // do something with the array of object returned by the call
            self.favorites = favorites;
            [self.tableView reloadData];
        } else {
            NSLog(@"Could not find any favorites - %@", error.localizedDescription);
        }
    }];
    
    
}

-(NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section{
    return self.favorites.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FavoriteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FavoriteCell" forIndexPath:indexPath];
    
    
    Favorite * currentFavorite = self.favorites[indexPath.row];
    cell.delegate = self;
    
    [self.apimanager fetchVenuewithVenueName:currentFavorite.venueName Latitude:currentFavorite.latitude Longitude:currentFavorite.longitude withCompletionHandler:^(Venue * venue, NSError * error){
        if(venue){
            NSLog(@"a favorite");
            cell.venue = venue;
            
            
        }
        else{
            NSLog(@"no favorites");
        }
        
        
    }];
    
    return cell;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
