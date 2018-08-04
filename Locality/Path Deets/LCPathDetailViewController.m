//
//  LCPathDetailViewController.m
//  Locality
//
//  Created by Youngmin Shin on 7/30/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "LCPathDetailViewController.h"
#import "LCMapView.h"

@interface LCPathDetailViewController ()
@property (weak, nonatomic) IBOutlet LCMapView *lcMapView;
@property (weak, nonatomic) IBOutlet UILabel *pathNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *pathDescriptionLabel;
@property (weak, nonatomic) IBOutlet PFImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) NSMutableArray *photosForSlideshow;
@property (weak, nonatomic) IBOutlet UIView *slideBarView;
@property (nonatomic) int currentPhotoIndex;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *uiImageView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;


@end

@implementation LCPathDetailViewController

#pragma mark - Navigation Controller
- (void)viewDidLoad {
    [super viewDidLoad];
    self.pathNameLabel.text = self.itinerary.name;
    self.pathDescriptionLabel.text = self.itinerary.pathDescription;
    self.userNameLabel.text = self.itinerary.creator.name;
    if (self.itinerary.creator.profilePicture != nil) {
        self.userProfileImageView.file = self.itinerary.creator.profilePicture;
        [self.userProfileImageView loadInBackground];
    }
    [self.lcMapView configureWithItinerary:self.itinerary isStatic:NO];
    [self seedTesterImageArray];
    
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeHandler:)];
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeHandler:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.slideBarView addGestureRecognizer:leftSwipe];
    [self.slideBarView addGestureRecognizer:rightSwipe];
    self.pageControl.numberOfPages = ([self.photosForSlideshow count] + 1);
    self.currentPhotoIndex = 0;
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

#pragma mark - Handling Swipe Gestures
- (void)rightSwipe{
    if (self.currentPhotoIndex != 0) {
        self.currentPhotoIndex --;
        self.pageControl.currentPage --;
    }
    if (self.currentPhotoIndex == 0) {
        [self.lcMapView configureWithItinerary:self.itinerary isStatic:NO];
        [self.view bringSubviewToFront:self.lcMapView];
        [self.view bringSubviewToFront:self.slideBarView];
        [self.view bringSubviewToFront:self.headerView];
        [self.view bringSubviewToFront:self.pathNameLabel];
        [self.view bringSubviewToFront:self.userProfileImageView];
        [self.view bringSubviewToFront:self.pathDescriptionLabel];
    } else {
        [self.view bringSubviewToFront:self.uiImageView];
        [self.view bringSubviewToFront:self.slideBarView];
        [UIView transitionWithView:self.uiImageView duration:1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            self.uiImageView.image = self.photosForSlideshow[self.currentPhotoIndex - 1];
        } completion:^(BOOL finished) {
        }];
    }
}
- (void)leftSwipe{
    if (self.currentPhotoIndex != [self.photosForSlideshow count]) {
        self.currentPhotoIndex ++;
        self.pageControl.currentPage ++;
    }
    [self.view bringSubviewToFront:self.uiImageView];
    [self.view bringSubviewToFront:self.slideBarView];
    [UIView transitionWithView:self.uiImageView duration:1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.uiImageView.image = self.photosForSlideshow[self.currentPhotoIndex - 1];
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - Image Array Seeder

- (void)seedTesterImageArray{
    self.photosForSlideshow = [[NSMutableArray alloc] init];
    [self.photosForSlideshow addObject:[UIImage imageNamed:@"golgenGate"]];
    [self.photosForSlideshow addObject:[UIImage imageNamed:@"centralpark"]];
    [self.photosForSlideshow addObject:[UIImage imageNamed:@"frenchfries"]];
    [self.photosForSlideshow addObject:[UIImage imageNamed:@"macaroons"]];
}


//- (void)

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
