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

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>
@property (strong, nonatomic) NSArray *itineraries;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) MBProgressHUD * hud;
@property (strong, nonatomic) UISearchController *searchController;
@end

@implementation HomeViewController

#pragma mark - View Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [self loadPathsWithCategory:@"Foodie"];
    //self.tableView.rowHeight=UITableViewAutomaticDimension;
    
    UISearchBar *searchBar = self.searchController.searchBar;
    [searchBar sizeToFit];
    searchBar.placeholder = @"Search for specific place";
    self.navigationItem.titleView = self.searchController.searchBar;
    self.searchController.obscuresBackgroundDuringPresentation = YES;
    self.definesPresentationContext = YES;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if(CLLocationManager.locationServicesEnabled){
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.locationManager requestLocation];
    }
}
- (void)reverseGeocode:(CLLocation *)location{

    if (!self.geoCoder){
        self.geoCoder = [[CLGeocoder alloc] init];
    }
  [self.geoCoder reverseGeocodeLocation:location preferredLocale:nil completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error){
      if(placemarks){
          CLPlacemark * placemark=[placemarks firstObject];
          self.cityName = placemark.locality;
        [self photoFecth];
     }else{
          //handle error
     }
    }];
}
#pragma mark - IBAction

- (IBAction)didTapFoodie:(id)sender {
    [self loadPathsWithCategory:@"Foodie"];
}

- (IBAction)didTapEntertainment:(id)sender {
    [self loadPathsWithCategory:@"Entertainment"];
}

- (IBAction)didTapNature:(id)sender {
    [self loadPathsWithCategory:@"Nature"];
}

- (IBAction)didTapCreatePath:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Start New Path?" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"Let's Go!" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self performSegueWithIdentifier:@"createSegue" sender:nil];
    }];
    [alert addAction:cancelAction];
    [alert addAction:continueAction];
    [self presentViewController:alert animated:YES completion:^{
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
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itineraries.count;
    //return 20;
}
#pragma mark - Flickr Request
-(void) photoFecth{
    self.apiKey = @"595a10deca33ce1b5a7ab291254fb22a";
    self.sharedKey = @"cf18c4e987fb5146";
    self.context = [[OFFlickrAPIContext alloc]
                  initWithAPIKey:self.apiKey sharedSecret:self.sharedKey];
    self.request1=[[OFFlickrAPIRequest alloc] initWithAPIContext:self.context];
    [self.request1 setDelegate:self];
    self.request2=[[OFFlickrAPIRequest alloc] initWithAPIContext:self.context];
    [self.request2 setDelegate:self];
NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:self.cityName,@"text", @"relevance",@"sort",@"views",@"extras", nil];
  [self.request1 callAPIMethodWithGET:@"flickr.photos.search" arguments:dictionary];
}
- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary{
    NSInteger currentLargestView=[inResponseDictionary[@"photos"][@"photo"][1][@"views"] integerValue];
    NSInteger secondLargestView=[inResponseDictionary[@"photos"][@"photo"][0][@"views"] integerValue];
    NSInteger thirdLargestView=0;
    NSMutableArray *arrayOfIndexsForLargestPhotoViews=[[NSMutableArray alloc] init];
    NSMutableArray * arrayOfPhotoUrl=[[NSMutableArray alloc] init];
    int save1 = 0,save2 = 0,save3 = 0;
      if(inRequest==self.request1){
   for(int i=0; i<100; i++){
    if([inResponseDictionary[@"photos"][@"photo"][i][@"views"] integerValue]>thirdLargestView){
          thirdLargestView=[inResponseDictionary[@"photos"][@"photo"][i][@"views"] integerValue];
          save3=i;
      }
      if([inResponseDictionary[@"photos"][@"photo"][i][@"views"] integerValue]>secondLargestView){
          thirdLargestView=secondLargestView;
          secondLargestView=[inResponseDictionary[@"photos"][@"photo"][i][@"views"] integerValue];
          save2=i;
      }
      if([inResponseDictionary[@"photos"][@"photo"][i][@"views"] integerValue]>currentLargestView){
          secondLargestView=currentLargestView;
          currentLargestView=[inResponseDictionary[@"photos"][@"photo"][i][@"views"] integerValue];
          save1=i;
      }
        
    }
           [arrayOfIndexsForLargestPhotoViews addObject:[NSNumber numberWithInteger:save1]];
           [arrayOfIndexsForLargestPhotoViews addObject:[NSNumber numberWithInteger:save2]];
           [arrayOfIndexsForLargestPhotoViews addObject:[NSNumber numberWithInteger:save3]];
           for(int i=0; i<arrayOfIndexsForLargestPhotoViews.count; i++){
              NSDictionary *photoDict = [[inResponseDictionary valueForKeyPath:@"photos.photo"] objectAtIndex:[arrayOfIndexsForLargestPhotoViews[i]integerValue]];
              NSURL *staticPhotoURL = [self.context photoSourceURLFromDictionary:photoDict size:OFFlickrMediumSize];
               NSString * string=[staticPhotoURL absoluteString];
               [arrayOfPhotoUrl addObject:[NSURL URLWithString:string]];
               NSLog(@"%@", staticPhotoURL);
          }
          NSString *urlStr1 =[NSString stringWithFormat:@"%@", arrayOfPhotoUrl[0]];
          NSURL *firstImageUrl=[NSURL URLWithString:urlStr1];
          UIImage * image1=[UIImage imageWithData:[NSData dataWithContentsOfURL:firstImageUrl]];
          NSString *urlStr2 =[NSString stringWithFormat:@"%@", arrayOfPhotoUrl[0]];
          NSURL *secondImageUrl=[NSURL URLWithString:urlStr2];
          UIImage * image2=[UIImage imageWithData:[NSData dataWithContentsOfURL:secondImageUrl]];
          NSString *urlStr3 =[NSString stringWithFormat:@"%@", arrayOfPhotoUrl[0]];
          NSURL *thirdImageUrl=[NSURL URLWithString:urlStr3];
          UIImage * image3=[UIImage imageWithData:[NSData dataWithContentsOfURL:thirdImageUrl]];
          self.labefiled.text=self.cityName;
          [self firstImageView:image1 secondImageView:image2 thirdImageView:image3];
          self.photoResponseDictionary=inResponseDictionary;
    }
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError{
    self.request1=nil;
    self.request2=nil;
}
#pragma mark - HeaderImageAnimation
-(void)firstImageView:(UIImage*)firstImage secondImageView:(UIImage*)secondImage thirdImageView:(UIImage*)thirdImage{
    NSMutableArray *images = [[NSMutableArray alloc]init];
    [images addObject:firstImage];
    [images addObject:secondImage];
    [images addObject:thirdImage];
    self.imageView.animationImages=[images copy];
    self.imageView.animationDuration=1;
    [self.imageView startAnimating];
}

#pragma mark - Location Manager
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *currentLocation = [locations lastObject];
    self.currentLocation = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    CLLocation *location =[[CLLocation alloc] initWithLatitude:self.currentLocation.latitude longitude:self.currentLocation.longitude];
    [self reverseGeocode:location];
    [self loadPathsWithCategory:@"Foodie"];
    [self photoFecth];
    [self.hud hideAnimated:YES];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"THERE WAS AN ERROR - %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error{
    NSLog(@"THERE WAS AN ERROR - %@", error);
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
