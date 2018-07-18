//
//  CollectionViewController.m
//  Locality
//
//  Created by Zelalem Tenaw Terefe on 7/18/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "CollectionViewController.h"
#import "UIImageView+AFNetworking.h"
@interface CollectionViewController ()

@end

@implementation CollectionViewController{
    NSDictionary * res;
}

-(void)viewDidLoad {
    [super viewDidLoad];
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

-(NSDictionary *) photodata:(NSString *) string{
    
    NSString * urlstring=[NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&per_page=10&format=json&nojsoncallback=1", self.Capikey, string];
    NSURL* url=[NSURL URLWithString:urlstring];
    NSURLRequest *req=[NSURLRequest requestWithURL:url];
    NSURLSession * session=[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            self->res = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"response: %@", self->res);
           
        }
    }];
   
    [task resume];
    
//    NSString *jsonString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
//
//    NSData * data=[jsonString dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary * dictionary=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
     return self->res;
   
}


-(void) fecth{
    [self apimanager];
    
    //[self.req callAPIMethodWithGET:@"flickr.photos.getRecent" arguments:[NSDictionary dictionaryWithObjectsAndKeys:@"1", @"per_page", nil]];
    [self.req callAPIMethodWithGET:@"flickr.photos.search" arguments:[self photodata:@"CAT"]];
    
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary{
    for(NSString *key in inResponseDictionary){
        NSLog(@"%@", [inResponseDictionary objectForKey:key]);
    }
    // OFFlickrAPIContext *flickrContext=[[OFFlickrAPIContext alloc] initWithAPIKey:@"595a10deca33ce1b5a7ab291254fb22a" sharedSecret:@"cf18c4e987fb5146"];
    
    NSDictionary *photoDict = [[inResponseDictionary valueForKeyPath:@"photos.photo"] objectAtIndex:0];
    NSURL *staticPhotoURL = [self.con photoSourceURLFromDictionary:photoDict size:OFFlickrSmallSize];
    NSURL *photoSourcePage = [self.con photoWebPageURLFromDictionary:photoDict];
    
    NSLog(@"%@", photoSourcePage);
    NSLog(@"%@", staticPhotoURL);
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

@end
