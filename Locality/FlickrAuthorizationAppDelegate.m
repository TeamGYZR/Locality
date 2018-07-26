//
//  FlickrAuthorizationAppDelegate.m
//  Locality
//
//  Created by Zelalem Tenaw Terefe on 7/25/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "FlickrAuthorizationAppDelegate.h"

NSString *kGetAccessTokenStep = @"kGetAccessTokenStep";
NSString *kCheckTokenStep = @"kCheckTokenStep";

NSString *SRCallbackURLBaseString = @"Locality://auth";
@implementation FlickrAuthorizationAppDelegate
- (OFFlickrAPIRequest *)flickrRequest
{
    if (!_flickrRequest) {
        _flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:self.flickrContext];
        _flickrRequest.delegate = self;
    }
    
    return _flickrRequest;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([self flickrRequest].sessionInfo) {
        // already running some other request
        NSLog(@"Already running some other request");
    }
    else {
        NSString *token = nil;
        NSString *verifier = nil;
        BOOL result = OFExtractOAuthCallback(url, [NSURL URLWithString:SRCallbackURLBaseString], &token, &verifier);
        
        if (!result) {
            NSLog(@"Cannot obtain token/secret from URL: %@", [url absoluteString]);
            return NO;
        }
        
        [self flickrRequest].sessionInfo = kGetAccessTokenStep;
        [_flickrRequest fetchOAuthAccessTokenWithRequestToken:token verifier:verifier];
        [_activityIndicator startAnimating];
        [_viewController.view addSubview:_progressView];
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [_window addSubview:_viewController.view];
    [_window makeKeyAndVisible];
    
    if ([self.flickrContext.OAuthToken length]) {
        [self flickrRequest].sessionInfo = kCheckTokenStep;
        [_flickrRequest callAPIMethodWithGET:@"flickr.test.login" arguments:nil];
        
        [_activityIndicator startAnimating];
        [_viewController.view addSubview:_progressView];
    }
    return YES;
}
- (OFFlickrAPIContext *)flickrContext{
    _flickrContext=self.flickrContext;
    //{
    //    if (!_flickrContext) {
    _flickrContext = [[OFFlickrAPIContext alloc] initWithAPIKey:@"64578e39784b1c34163d4c53d924455b" sharedSecret:@"f14090263ea6b80c"];
    
    //        NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:kStoredAuthTokenKeyName];
    //        NSString *authTokenSecret = [[NSUserDefaults standardUserDefaults] objectForKey:kStoredAuthTokenSecretKeyName];
    //
    //        if (([authToken length] > 0) && ([authTokenSecret length] > 0)) {
    //            _flickrContext.OAuthToken = authToken;
    //            _flickrContext.OAuthTokenSecret = authTokenSecret;
    //        }
    //    }
    //
    return _flickrContext;
}
+ (FlickrAuthorizationAppDelegate *)sharedDelegate
{
    return (FlickrAuthorizationAppDelegate *)[[UIApplication sharedApplication] delegate];
}
@end
