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



@interface HomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) NSArray *itineraries;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
//@property (strong, nonatomic) CLLocation *currentCoordinateLocation;

@end

@implementation HomeViewController

#pragma mark - View Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadPathsWithCategory:@"Foodie"];
    [self photoFecth];
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
    PFQuery *query = [PFQuery queryWithClassName:@"Itenerary"];
    [query whereKey:@"category" equalTo:category];
    //this might not be necessary
    [query includeKey:@"path"];
    [query includeKey:@"creator"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *iteneraries, NSError *error){
        if (error) {
            NSLog(@"error loading paths from Parse");
        } else {
            self.itineraries = iteneraries;
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
  NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"San francisco", @"text",@"relevance",@"sort",nil];
    [self.request1 callAPIMethodWithGET:@"flickr.photos.search" arguments:dictionary];
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary{
    NSInteger * largestInteger=0;
    if(inRequest==self.request1){
  //NSLog(@"response: %@", inResponseDictionary);
    self.photoResponseDictionary=inResponseDictionary;
    }
    NSString * string;
    for(int i=0; i<100; i++){
     string=self.photoResponseDictionary[@"photos"][@"photo"][i][@"id"];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:self.apiKey, @"api_key",string, @"photo_id",nil];
      bool boo=[self.request2 callAPIMethodWithGET:@"flickr.photos.getFavorites" arguments:dictionary];
        //NSLog(@"%@", inResponseDictionary[@"photo"][@"total"]);
        NSLog(@"%d", boo);
        //NSLog(@"%@", inResponseDictionary);
    //NSLog(@"%@", string);
      }
//    if(inRequest==self.request2){
//        NSLog(@"%@", inResponseDictionary);
//    }
    

}





- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError{
    self.request1=nil;
    self.request2=nil;
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
