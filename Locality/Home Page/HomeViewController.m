//
//  HomeViewController.m
//  Locality
//
//  Created by Zelalem Tenaw Terefe on 7/27/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) photoFecth{
    self.apiKey = @"595a10deca33ce1b5a7ab291254fb22a";
    self.sharedKey = @"cf18c4e987fb5146";
    self.context = [[OFFlickrAPIContext alloc]
                  initWithAPIKey:self.apiKey sharedSecret:self.sharedKey];
    self.request=[[OFFlickrAPIRequest alloc] initWithAPIContext:self.context];
    [self.request setDelegate:self];
  NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@
                              "San francisco", @"text",nil];
    [self.request callAPIMethodWithGET:@"flickr.photos.search" arguments:dictionary];
}
- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary{
  NSLog(@"response: %@", inResponseDictionary);
    
    
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
