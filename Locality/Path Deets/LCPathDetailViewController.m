//
//  LCPathDetailViewController.m
//  Locality
//
//  Created by Youngmin Shin on 7/30/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "LCPathDetailViewController.h"
#import "LCMapView.h"
#import "Parse.h"             
#import "PathFavorite.h"
#import "User.h"
#import "StartPathViewController.h"

@interface LCPathDetailViewController ()
@property (weak, nonatomic) IBOutlet LCMapView *lcMapView;
@property (weak, nonatomic) IBOutlet UILabel *pathNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) NSMutableArray *photosForSlideshow;
@property (weak, nonatomic) IBOutlet UIView *slideBarView;
@property (nonatomic) int currentPhotoIndex;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet PFImageView *pfImageView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *pinTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UILabel *viewLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (strong, nonatomic) IBOutlet UILabel *timeStampLabel;
@property (nonatomic) BOOL favorited;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIView *pinDescriptionView;
@property (weak, nonatomic) IBOutlet UIView *pinNameView;

@property (weak, nonatomic) IBOutlet UIView *pinnedLocationView;
@property (weak, nonatomic) IBOutlet UITextView *pinDescriptionTextView;
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *titleLongPressGesture;

@end

@implementation LCPathDetailViewController
#pragma mark - Navigation Controller
- (void)viewDidLoad {
    [super viewDidLoad];
    self.pathNameLabel.text = self.itinerary.name;
    [self.pathNameLabel sizeToFit];
    self.descriptionTextView.text = self.itinerary.pathDescription;
    self.descriptionTextView.layer.borderWidth = 2.0;
    self.descriptionTextView.layer.borderColor = [UIColor colorWithRed:.1843 green:.28235 blue:.34509 alpha:.7].CGColor;
    self.descriptionTextView.clipsToBounds= YES;
    self.pinNameView.layer.borderWidth = 1.0;
    self.pinNameView.layer.borderColor = [UIColor colorWithRed:.1843 green:.28235 blue:.34509 alpha:.7].CGColor;
    self.pinNameView.clipsToBounds= YES;
    self.pinDescriptionView.layer.borderWidth = 1.0;
    self.pinDescriptionView.layer.borderColor = [UIColor colorWithRed:.1843 green:.28235 blue:.34509 alpha:.7].CGColor;
    self.pinDescriptionView.clipsToBounds= YES;
    self.userNameLabel.text = self.itinerary.creator.name;
    self.viewLabel.text = [NSString stringWithFormat:@"%lu", [self.itinerary.uniqueUserViews count]];
    User *currentUser = (User *)[PFUser currentUser];
    if(![[self.itinerary.uniqueUserViews copy] containsObject:currentUser.name]){
        [self.itinerary addObject:currentUser.name forKey:@"uniqueUserViews"];
        [self.itinerary saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
            NSLog(@"user has been saved");
        }];
    }
    if(self.itinerary.timeStamp){
        self.timeStampLabel.text = self.itinerary.timeStamp; 
    }
    [self.lcMapView configureWithItinerary:self.itinerary isStatic:NO showCurrentLocation:YES];
    [self setImageArray];
    [self queryForPathFavorite];
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeHandler:)];
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeHandler:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.slideBarView addGestureRecognizer:leftSwipe];
    [self.slideBarView addGestureRecognizer:rightSwipe];
    self.pageControl.numberOfPages = ([self.photosForSlideshow count] + 1);
    self.currentPhotoIndex = 0;
    [self.titleLongPressGesture setMinimumPressDuration:.5];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:.1843 green:.28235 blue:.34509 alpha:1], NSFontAttributeName:[UIFont fontWithName:@"Dosis-Bold" size:21]}];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:.1843 green:.28235 blue:.34509 alpha:1], NSFontAttributeName:[UIFont fontWithName:@"Dosis-Regular" size:21]} forState:UIControlStateNormal];
}

#pragma mark - Actions

- (IBAction)didTapBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)swipeHandler:(UISwipeGestureRecognizer *)recognizer{
    if (recognizer.direction == 1) {
        [self rightSwipe];
    } else if (recognizer.direction == 2){
        [self leftSwipe];
    }
}
- (IBAction)didTapFavorite:(id)sender {
    if (self.favorited) {
        [PathFavorite removeFavoritedPath:(Itinerary * _Nullable)self.itinerary withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (error) {
                NSLog(@"error removing path");
            } else{
                [self setAnEmptyStar];
                self.favorited = NO;
                NSLog(@"successfully unfavorited path");
            }
        }];
    } else {
        [PathFavorite saveFavoritedPath:(Itinerary * _Nullable)self.itinerary withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (error) {
                NSLog(@"error favoriting path");
            } else{
                [self setAFilledStar];
                self.favorited = YES;
                NSLog(@"succesfully favorited path");
            }
        }];
    }
}

- (IBAction)handleLongPress:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded");
    }
    else if (sender.state == UIGestureRecognizerStateBegan){
        NSLog(@"UIGestureRecognizerStateBegan.");
        [self beginTextToSpeech];
        
    }
}

- (IBAction)didTapShare:(id)sender {
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:context];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[snapshotImage] applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[];
    activityViewController.popoverPresentationController.sourceView = self.view;
    activityViewController.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/4, 0, 0);
    [self presentViewController:activityViewController animated:true completion:nil];
    [activityViewController setCompletionWithItemsHandler:^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            NSLog(@"Activity type: %@", activityType);
        } else {
            NSLog(@"User cancelled out of share");
        }
        if (activityError) {
            NSLog(@"error regarding sharing with Activity VC");
        }
    }];
}


#pragma mark - Handling Favorites

-(void)setAFilledStar{
    UIImage *favoriteButtonImage = [UIImage imageNamed:@"filledBlueStar"];
    [self.favoriteButton setImage:favoriteButtonImage forState:UIControlStateNormal];
}

-(void)setAnEmptyStar{
    UIImage *unfavoriteButtonImage = [UIImage imageNamed:@"emptyBlueStar"];
    [self.favoriteButton setImage:unfavoriteButtonImage forState:UIControlStateNormal];
}

- (void)queryForPathFavorite{
    PFQuery *query = [PFQuery queryWithClassName:@"PathFavorite"];
    [query whereKey:@"user" equalTo:PFUser.currentUser];
    [query whereKey:@"itinerary" equalTo:self.itinerary];
    [query includeKeys:@[@"user", @"itinerary"]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable pathFavorite, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error fetching favorite from parse");
        } else if (pathFavorite){
            [self setAFilledStar];
            self.favorited = YES;
        } else {
            [self setAnEmptyStar];
            self.favorited = NO;
        }
    }];
}
#pragma mark - Handling Swipe Gestures
- (void)rightSwipe{
    if (self.currentPhotoIndex != 0) {
        self.currentPhotoIndex --;
        self.pageControl.currentPage --;
    }
    if (self.currentPhotoIndex == 0) {
        [self setMap];
    } else{
        [self setImage];
        [self transitionToImageFromDirectionRight:NO];
    }
}
- (void)leftSwipe{
    if (self.currentPhotoIndex != [self.photosForSlideshow count]) {
        self.currentPhotoIndex ++;
        self.pageControl.currentPage ++;
        [self setImage];
        [self transitionToImageFromDirectionRight:YES];
    }
}
#pragma mark - Private Methods
- (void)setImageArray{
    self.photosForSlideshow = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.itinerary.pinnedLocations count]; i++) {
        if (self.itinerary.pinnedLocations[i][@"pictureData"] != nil) {
            [self.photosForSlideshow addObject:self.itinerary.pinnedLocations[i][@"pictureData"]];
        }
    }
}

- (void)setMap{
    [self.lcMapView configureWithItinerary:self.itinerary isStatic:NO showCurrentLocation:YES];
    [self.view bringSubviewToFront:self.lcMapView];
    [self.view bringSubviewToFront:self.slideBarView];
    [self.view bringSubviewToFront:self.headerView];
    [self.view bringSubviewToFront:self.pathNameLabel];
    [self.view bringSubviewToFront:self.startButton];
    [self.view bringSubviewToFront:self.favoriteButton];
}
- (void)setImage{
    self.pinTitleLabel.text = self.itinerary.pinnedLocations[self.currentPhotoIndex - 1][@"name"];
    [self.pinTitleLabel sizeToFit];
    self.pinDescriptionTextView.text = self.itinerary.pinnedLocations[self.currentPhotoIndex - 1][@"description"];
    self.pfImageView.file = self.photosForSlideshow[self.currentPhotoIndex - 1];
    [self.pfImageView loadInBackground];
}

- (void) transitionToImageFromDirectionRight:(BOOL)right{
    CATransition *transition = [CATransition animation];
    if (right) {
        transition.subtype = kCATransitionFromRight;
    } else {
        transition.subtype = kCATransitionFromLeft;
    }
    transition.duration = .5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self.view bringSubviewToFront:self.pinnedLocationView];
    [self.view bringSubviewToFront:self.slideBarView];
}

- (void) beginTextToSpeech{
    if(!self.speech.isSpeaking){
        AVSpeechUtterance *speechUtterance=[[AVSpeechUtterance alloc] initWithString:self.itinerary[@"name"]];
        speechUtterance.rate=0.5;
        speechUtterance.voice=[AVSpeechSynthesisVoice voiceWithLanguage:@"en_IE"];
        self.speech=[[AVSpeechSynthesizer alloc] init];
        [self.speech speakUtterance:speechUtterance];
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"segueToDirections"]){
        UINavigationController *navigationController = [segue destinationViewController];
        StartPathViewController *nextViewController = (StartPathViewController*)navigationController.topViewController;
        nextViewController.itinerary = self.itinerary;
    }
}
@end
