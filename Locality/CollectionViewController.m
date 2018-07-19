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
    
    // Do any additional setup after loading the view.
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
    
    //[self.req callAPIMethodWithGET:@"flickr.photos.getRecent" arguments:[NSDictionary dictionaryWithObjectsAndKeys:@"1", @"per_page", nil]];

//    Venue *ve=[[Venue alloc] init];
//    NSLog(@"%@", ve.latitude);
//

    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"50", @"per_page",self.name, @"text", nil];
    //[self.req callAPIMethodWithGET:@"flickr.photos.getRecent" arguments:dictionary];
    [self.req callAPIMethodWithGET:@"flickr.photos.search" arguments:dictionary];
    
    
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary{
//    for(NSString *key in inResponseDictionary){
//        NSLog(@"%@", [inResponseDictionary objectForKey:key]);
//    }
    // OFFlickrAPIContext *flickrContext=[[OFFlickrAPIContext alloc] initWithAPIKey:@"595a10deca33ce1b5a7ab291254fb22a" sharedSecret:@"cf18c4e987fb5146"];
    
  NSLog(@"response: %@", inResponseDictionary);
//    for(int i=0; i<inResponseDictionary.allKeys.count; i++){
  // NSDictionary *photoDict = [[inResponseDictionary valueForKeyPath:@"photos.photo"] objectAtIndex:0];
    //NSURL *staticPhotoURL = [self.con photoSourceURLFromDictionary:photoDict size:OFFlickrSmallSize];
    //NSURL *photoSourcePage = [self.con photoWebPageURLFromDictionary:photoDict];
//
   //NSLog(@"%@", photoSourcePage);
    
  //NSLog(@"%@", staticPhotoURL);
//    }
    
    self->res=inResponseDictionary;
 
    [self.collectionview reloadData];
    request = nil;
    
}


- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError{
    request = nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/











- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSLog(@"starting reloadData");
    CollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"collectioncell" forIndexPath:indexPath];
    NSDictionary *photoDict = [[self->res valueForKeyPath:@"photos.photo"] objectAtIndex:indexPath.item];
   NSURL *staticPhotoURL = [self.con photoSourceURLFromDictionary:photoDict size:OFFlickrSmallSize];
    cell.url=staticPhotoURL;
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [ self->res[@"photos"][@"perpage"] integerValue];
}



@end
