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


@interface Uploadphotoviewcontroller : UIViewController <UIApplicationDelegate, OFFlickrAPIRequestDelegate>
@property CollectionViewCell * cells;

@property (strong,nonatomic) OFFlickrAPIRequest *flickrRequest;
@property (strong, nonatomic) OFFlickrAPIContext *flickrContext;


@end
