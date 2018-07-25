//
//  Uploadphotoviewcontroller.h
//  Locality
//
//  Created by Zelalem Tenaw Terefe on 7/23/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionViewCell.h"
#import <ObjectiveFlickr/ObjectiveFlickr.h>


@interface Uploadphotoviewcontroller : UIViewController <OFFlickrAPIRequestDelegate>
@property CollectionViewCell * cells;
@property (strong,nonatomic) OFFlickrAPIContext * con;
@property (strong, nonatomic) OFFlickrAPIRequest *req;
@property (strong,nonatomic) NSString * Capikey;
@property (strong, nonatomic) NSString * Csharedkey;
@property (strong,nonatomic) OFFlickrAPIContext * cons;
@property (strong, nonatomic) OFFlickrAPIRequest *reqs;



@end
