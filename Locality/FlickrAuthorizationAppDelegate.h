//
//  FlickrAuthorizationAppDelegate.h
//  Locality
//
//  Created by Zelalem Tenaw Terefe on 7/25/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectiveFlickr.h"

@interface FlickrAuthorizationAppDelegate : UIResponder <UIApplicationDelegate, OFFlickrAPIRequestDelegate>

+ (FlickrAuthorizationAppDelegate *)sharedDelegate;
@property (strong,nonatomic) OFFlickrAPIRequest *flickrRequest;
@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic)  OFFlickrAPIContext *flickrContext;
//@property (strong,nonatomic) OFFlickrAPIRequest *flickrRequest;
@property  NSString *flickrUserName;
@property  IBOutlet UINavigationController *viewController;
@property  IBOutlet UIActivityIndicatorView *activityIndicator;
@property IBOutlet UIView *progressView;
@end
extern NSString *SRCallbackURLBaseString;
