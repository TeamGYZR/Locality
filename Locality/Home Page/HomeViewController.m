//
//  HomeViewController.m
//  Locality
//
//  Created by Zelalem Tenaw Terefe on 7/27/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "HomeViewController.h"
#import "Parse.h"
#import "PathCell.h"
#import "math.h"
#import "Itinerary.h"
#import "User.h"
#import <ParseUI/ParseUI.h>
#import "LCPathDetailViewController.h"
#import "MBProgressHUD.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "PlacesSearchTableViewController.h"
#import "CLLocationManagerSingleton.h"

//rounded edges and shadow
#import <QuartzCore/QuartzCore.h>

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>
@property (strong, nonatomic) NSArray *itineraries;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) MBProgressHUD * hud;
@property (strong, nonatomic) UISearchController *searchController;
@property (weak, nonatomic) IBOutlet UIButton *foodieButton;
@property (weak, nonatomic) IBOutlet UIButton *entertainmentButton;
@property (weak, nonatomic) IBOutlet UIButton *natureButton;
@property (strong, nonatomic) PlacesSearchTableViewController *searchTableViewController;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *createPathBarButton;

@end

@implementation HomeViewController

#pragma mark - View Controller
-(void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [self loadPathsWithCategory:@"Foodie"];
    self.labefiled.alpha=0;
    //self.tableView.rowHeight=UITableViewAutomaticDimension;
    //self.tableView.rowHeight=UITableViewAutomaticDimension;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:[NSBundle mainBundle]];
    PlacesSearchTableViewController *pathsSearchTable = [storyboard instantiateViewControllerWithIdentifier:@"ResultsTable"];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:pathsSearchTable];
    self.searchController.searchResultsUpdater = pathsSearchTable;
    pathsSearchTable.tableView.delegate = self;
    pathsSearchTable.itineraries = nil;
    self.searchTableViewController = pathsSearchTable;
    UISearchBar *searchBar = self.searchController.searchBar;
    [searchBar sizeToFit];
    searchBar.placeholder = @"Search by pins";
    searchBar.delegate = self;
    //searchBar.barTintColor = [UIColor colorWithRed:0.96078 green:1.0 blue:0.8039 alpha:0.5];
    self.navigationItem.titleView = self.searchController.searchBar;
    self.searchController.obscuresBackgroundDuringPresentation = YES;
    self.definesPresentationContext = YES;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.locationManager = [CLLocationManagerSingleton sharedSingleton].locationManager;
    self.locationManager.delegate = self;
    if(CLLocationManager.locationServicesEnabled){
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.label.text = @"Fetching paths...";
        self.hud.contentColor = [UIColor colorWithRed:0 green:0.2 blue:0.453 alpha:1];
        [self.locationManager requestLocation];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
}

- (void)viewWillDisappear:(BOOL)animated{
    self.locationManager.delegate = nil;
}

- (void)reverseGeocode:(CLLocation *)location{
    if (!self.geoCoder){
        self.geoCoder = [[CLGeocoder alloc] init];
    }
  [self.geoCoder reverseGeocodeLocation:location preferredLocale:nil completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error){
      if(placemarks){
          CLPlacemark * placemark=[placemarks firstObject];
          self.labefiled.text = placemark.locality;
          self.labefiled.alpha=1;
          [self.hud hideAnimated:YES];
        //[self photoFecth];
     }else{
          //handle error
     }
  }];
}
#pragma mark - IBAction
- (IBAction)didTapFoodie:(id)sender{
    [self loadPathsWithCategory:@"Foodie"];
    [self.foodieButton setTitleColor:[UIColor colorWithRed:.9254 green:.41176 blue:.30196 alpha:1] forState:UIControlStateNormal];
    [self.entertainmentButton setTitleColor:[UIColor colorWithRed:.1843 green:.28235 blue:.34509 alpha:1] forState:UIControlStateNormal];
    [self.natureButton setTitleColor:[UIColor colorWithRed:.1843 green:.28235 blue:.34509 alpha:1] forState:UIControlStateNormal];
}
     

- (IBAction)didTapEntertainment:(id)sender {
    [self loadPathsWithCategory:@"Entertainment"];
    [self.entertainmentButton setTitleColor:[UIColor colorWithRed:.9254 green:.41176 blue:.30196 alpha:1] forState:UIControlStateNormal];
    [self.foodieButton setTitleColor:[UIColor colorWithRed:.1843 green:.28235 blue:.34509 alpha:1] forState:UIControlStateNormal];
    [self.natureButton setTitleColor:[UIColor colorWithRed:.1843 green:.28235 blue:.34509 alpha:1] forState:UIControlStateNormal];
}

- (IBAction)didTapNature:(id)sender {
    [self loadPathsWithCategory:@"Nature"];
    [self.natureButton setTitleColor:[UIColor colorWithRed:.9254 green:.41176 blue:.30196 alpha:1] forState:UIControlStateNormal];
    [self.entertainmentButton setTitleColor:[UIColor colorWithRed:.1843 green:.28235 blue:.34509 alpha:1] forState:UIControlStateNormal];
    [self.foodieButton setTitleColor:[UIColor colorWithRed:.1843 green:.28235 blue:.34509 alpha:1] forState:UIControlStateNormal];
}

- (IBAction)didTapCreatePath:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Start New Path?" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"Let's Go!" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self performSegueWithIdentifier:@"createSegue" sender:self];
    }];
    [alert addAction:cancelAction];
    [alert addAction:continueAction];
    [self presentViewController:alert animated:YES completion:^{
        NSLog(@"hey");
    }];
}
#pragma mark - Parse Query
- (void) loadPathsWithCategory:(NSString *)category{
    PFQuery *query = [PFQuery queryWithClassName:@"Itinerary"];
    [query whereKey:@"category" equalTo:category];
    [query includeKey:@"path"];
    [query includeKey:@"creator"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *iteneraries, NSError *error){
        if (error) {
            NSLog(@"error loading paths from Parse");
        } else {
            self.itineraries = iteneraries;
            [self sortItenerariesByDistance];
            [self.tableView reloadData];
            NSIndexPath *topPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView scrollToRowAtIndexPath:topPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    }];
}
#pragma mark - Private Methods
- (void) sortItenerariesByDistance{
    for (int i = 0; i < self.itineraries.count; i++) {
        CLLocationCoordinate2D venueCoordinate;
        venueCoordinate.latitude = [self.itineraries[i][@"pinnedLocations"][0][@"latitude"] doubleValue];
        venueCoordinate.longitude = [self.itineraries[i][@"pinnedLocations"][0][@"longitude"] doubleValue];
        CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:self.currentLocation.latitude longitude:self.currentLocation.longitude];
        CLLocation *venueLocation = [[CLLocation alloc] initWithLatitude:venueCoordinate.latitude longitude:venueCoordinate.longitude];
        CLLocationDistance distance = [currentLocation distanceFromLocation:venueLocation];
        self.itineraries[i][@"distanceFromFirstPinnedLocation"] = [NSNumber numberWithDouble:distance];
        //NSLog(@"%@", self.itineraries[i][@"distanceFromFirstPinnedLocation"]);
        [self.itineraries[i] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error) {
                NSLog(@"error saving distance to parse");
            } else {
                NSLog(@"success saving distance to parse");
            }
        }];
    }
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distanceFromFirstPinnedLocation" ascending:YES];
    self.itineraries = [self.itineraries sortedArrayUsingDescriptors:@[sortDescriptor]];
}

#pragma mark - UITableView
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PathCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PathCell" forIndexPath:indexPath];
    cell.itinerary = self.itineraries[indexPath.row];
    cell.cellView.layer.cornerRadius = 20.0;
    cell.cellView.layer.borderWidth = 2.0;
    cell.cellView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.cellView.layer.masksToBounds = YES;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itineraries.count;
    //return 20;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - Flickr Request
-(void) photoFecth{
    self.apiKey = @"595a10deca33ce1b5a7ab291254fb22a";
    self.sharedKey = @"cf18c4e987fb5146";
    self.context = [[OFFlickrAPIContext alloc]
                    initWithAPIKey:self.apiKey sharedSecret:self.sharedKey];
    self.request=[[OFFlickrAPIRequest alloc] initWithAPIContext:self.context];
    [self.request setDelegate:self];
   NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:self.cityName,@"text", @"relevance",@"sort",@"views",@"extras", nil];
    [self.request callAPIMethodWithGET:@"flickr.photos.search" arguments:dictionary];
}

-(void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary{
    NSInteger currentLargestView=0;
    int IndexForTheLargestViewedPhoto=0;
    if (inRequest==self.request){
        for (int i=0; i<100; i++){
            if([inResponseDictionary[@"photos"][@"photo"][i][@"views"] integerValue]>currentLargestView){
                currentLargestView=[inResponseDictionary[@"photos"][@"photo"][i][@"views"] integerValue];
                IndexForTheLargestViewedPhoto=i;
            }
            
        }
            NSDictionary *photoDict = [[inResponseDictionary valueForKeyPath:@"photos.photo"] objectAtIndex:IndexForTheLargestViewedPhoto];
            NSURL *staticPhotoURL = [self.context photoSourceURLFromDictionary:photoDict size:OFFlickrMediumSize];
            NSLog(@"%@", staticPhotoURL);
       
        [self.imageView setImageWithURLRequest:[NSURLRequest requestWithURL:staticPhotoURL] placeholderImage:[UIImage imageNamed:@"placeHolderImage"] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            self.imageView.alpha = 0.0;
            self.imageView.image = image;
            [UIView animateWithDuration:0.25
                             animations:^{
                                 self.imageView.alpha = 1.0;
                                 self.labefiled.alpha=1;
                                 self.labefiled.text=self.cityName;
                                 
                              }];
          }failure:^(NSURLRequest *request, NSHTTPURLResponse * _Nullable response, NSError *error){
            if(error){
                self.imageView.image=[UIImage imageNamed:@"placeHolderImage"];
            }
        }];
        self.photoResponseDictionary=inResponseDictionary;
    }
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError{
    self.request=nil;
}

#pragma mark - Location Manager
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *currentLocation = [locations lastObject];
    self.currentLocation = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    CLLocation *location =[[CLLocation alloc] initWithLatitude:self.currentLocation.latitude longitude:self.currentLocation.longitude];
    [self reverseGeocode:location];
    //[self loadPathsWithCategory:@"Foodie"];
    self.imageView.image = [UIImage imageNamed:@"menlopark"];
    //[self photoFecth];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"THERE WAS AN ERROR - %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error{
    NSLog(@"THERE WAS AN ERROR - %@", error);
}

#pragma mark - Search Controller Delegate

- (void)didPresentSearchController:(UISearchController *)searchController{
    CGRect createPathFrame = self.createPathBarButton.accessibilityFrame;
    createPathFrame.origin.x += 60;
    [UIView animateWithDuration:1.0 animations:^{
        self.navigationItem.rightBarButtonItem.accessibilityFrame = createPathFrame; 
    }];
    
}

#pragma mark - Search Bar Delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [UIView animateWithDuration:1.5 animations:^{
        self.navigationItem.rightBarButtonItem = nil;
    }];

}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchController.searchBar.text = @"";
    [self.tableView reloadData];
    [self.searchController.searchBar resignFirstResponder];
    self.navigationItem.rightBarButtonItem = self.createPathBarButton;
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"segueToDetails"]){
        PathCell * tappedCell = sender;
        NSIndexPath * indexPath = [self.tableView indexPathForCell:tappedCell];
        Itinerary * detailItinerary = self.itineraries[indexPath.row];
        UINavigationController *navigationController = [segue destinationViewController];
        LCPathDetailViewController *pathDetailsController = (LCPathDetailViewController*)navigationController.topViewController;
        pathDetailsController.itinerary = detailItinerary;
    }
}
@end
     
     
    
