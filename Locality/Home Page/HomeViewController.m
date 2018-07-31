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



@interface HomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) NSArray *itineraries;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation HomeViewController

#pragma mark - View Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self dummyItinerary];
    [self loadPathsWithCategory:@"Foodie"];
    //[self photoFecth];
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
        }
    }];
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.itineraries.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    PathCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PathCell" forIndexPath:indexPath];
    cell.itinerary = self.itineraries[indexPath.item];
    return cell;
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

- (void) dummyItinerary{
    Itinerary *itinerary = [Itinerary new];
    itinerary.name = @"ginger";
    itinerary.creator = [User currentUser];
    itinerary.pathDescription = @"this is a great path";
    itinerary.category = @"Foodie";
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"50.8199", @"latitude", @"122.4783", @"longitude" , nil];
    itinerary.pinnedLocations = [NSMutableArray arrayWithObjects:dictionary, nil];
    itinerary.distanceFromFirstPinnedLocation = nil;
    [itinerary saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error saving itinerary to parse");
        } else {
            NSLog(@"success saving itinerary to parse");
        }
    }];
}


#pragma mark - Flickr Request
-(void) photoFecth{
    self.apiKey = @"595a10deca33ce1b5a7ab291254fb22a";
    self.sharedKey = @"cf18c4e987fb5146";
    self.context = [[OFFlickrAPIContext alloc]
                  initWithAPIKey:self.apiKey sharedSecret:self.sharedKey];
    self.request=[[OFFlickrAPIRequest alloc] initWithAPIContext:self.context];
    [self.request setDelegate:self];
  NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"San francisco", @"text",@"relevance",@"sort",nil];
    [self.request callAPIMethodWithGET:@"flickr.photos.search" arguments:dictionary];
}
- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary{
  NSLog(@"response: %@", inResponseDictionary);
    self.photoResponseDictionary=inResponseDictionary;
    
    for(int i=0; i<100; i++){
    NSDictionary *photoDict =[[self.photoResponseDictionary valueForKeyPath:@"photos.photo"] objectAtIndex:i];
   NSLog(@"%@", [self.context photoSourceURLFromDictionary:photoDict size:OFFlickrLargeSize]);
    }
}
- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError{
    self.request=nil;
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
