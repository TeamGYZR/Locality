//
//  CollectionViewController.m
//  Locality
//
//  Created by Zelalem Tenaw Terefe on 7/18/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "CollectionViewController.h"
#import "UIImageView+AFNetworking.h"
#import "ExploreMapViewController.h"
#import "DetailsViewController.h"

@interface CollectionViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation CollectionViewController{
    NSDictionary * res;
   
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.collectionview.dataSource=self;
    self.collectionview.delegate=self;
    [self setkey];
    [self fecth];
    UICollectionViewFlowLayout * layout= (UICollectionViewFlowLayout *) self.collectionview.collectionViewLayout;
    layout.minimumLineSpacing=3;
    layout.minimumInteritemSpacing=3;
    
    
    CGFloat posterperline=3;
    CGFloat width=(self.collectionview.frame.size.width-layout.minimumInteritemSpacing *(posterperline-1))/posterperline;
    CGFloat height=width;
    layout.itemSize=CGSizeMake(width, height);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) setkey{
    apikey=@"595a10deca33ce1b5a7ab291254fb22a";
    sharedkey=@"cf18c4e987fb5146";
    self.Capikey=apikey;
    self.Csharedkey=sharedkey;
}
-(void) apimanager{
    context= [[OFFlickrAPIContext alloc]
              initWithAPIKey:self.Capikey sharedSecret:self.Csharedkey];
    request=[[OFFlickrAPIRequest alloc] initWithAPIContext:context];
    [request setDelegate:self];
    self.con=context;
    self.req=request;
}
-(void) fecth{
    [self apimanager];
    NSLog(@"%@", self.venue.latitude);
NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:self.venue.latitude,@"lat", self.venue.longitude,@"lon", self.name, @"text",@"relevance",@"sort", nil];
  [self.req callAPIMethodWithGET:@"flickr.photos.search" arguments:dictionary];
    
    
}

-(void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary{

    NSLog(@"response: %@", inResponseDictionary);
   self->res=inResponseDictionary;
   self.arraywithdictionary=[NSMutableArray array];
    self.arraywithdictionary=self->res[@"photos"][@"photo"];
    
    
    //SETTING THE HEADER PHOTO URL IN THE VENUE TO THE FIRST PHOTO FROM MY COLLLCATION VIEW PHOTO ARRRAY
    NSDictionary *photoDict =[[self->res valueForKeyPath:@"photos.photo"] objectAtIndex:0];
  NSURL * urlphoto=[self.con photoSourceURLFromDictionary:photoDict size:OFFlickrLargeSize];
   self.venue.headerPicURL=urlphoto;
    //SETTING THE HEADER PHOTO URL IN THE VENUE TO THE FIRST PHOTO FROM MY COLLLCATION VIEW PHOTO ARRRAY
    [self.collectionview reloadData];
    request = nil;
    
}
- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError{
    request = nil;
}
-(nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSLog(@"starting reloadData");
   CollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"collectioncell" forIndexPath:indexPath];
    NSDictionary *photoDict = [[self->res valueForKeyPath:@"photos.photo"] objectAtIndex:indexPath.item];
    
  
   NSURL *staticPhotoURL = [self.con photoSourceURLFromDictionary:photoDict size:OFFlickrSmallSize];
    NSLog(@"%lu", (unsigned long)photoDict.count);
    
    cell.url=staticPhotoURL;
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arraywithdictionary.count;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"detaillsegue"] || [segue.identifier isEqualToString:@"detaillview"] ){
        DetailsViewController *detail=[segue destinationViewController];
        detail.venue=self.venue;
        }
}



@end
