//
//  CollectionViewController.h
//  Locality
//
//  Created by Zelalem Tenaw Terefe on 7/18/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ObjectiveFlickr/ObjectiveFlickr.h>

@interface CollectionViewController : UIViewController <OFFlickrAPIRequestDelegate>{
    OFFlickrAPIContext *context;
    OFFlickrAPIRequest * request;
    NSString * apikey;
    NSString * sharedkey;
    
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary;

@property (strong,nonatomic) OFFlickrAPIContext * con;
@property (strong, nonatomic) OFFlickrAPIRequest *req;

-(void) fecth;
-(void) setkey;
-(void) apimanager;

@property (strong,nonatomic) NSString * Capikey;
@property (strong, nonatomic) NSString * Csharedkey;
@property (strong, nonatomic) NSDictionary * result;
@end
