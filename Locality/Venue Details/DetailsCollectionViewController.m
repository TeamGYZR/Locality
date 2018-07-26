//
//  DetailsCollectionViewController.m
//  Locality
//
//  Created by Ginger Dudley on 7/24/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "DetailsCollectionViewController.h"
#import "Parse.h"
#import "CommentCell.h"
#import "DetailsHeaderView.h"
#import "APImanager.h"
#import "CommentCollectionCell.h"
#import "UIImageView+AFNetworking.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface DetailsCollectionViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *comments;
@property APIManager *apiManager;
@property(nonatomic) BOOL favorited;
@property(strong, nonatomic)DetailsHeaderView *header;

@end

@implementation DetailsCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.apiManager = [APIManager new];
    [self loadComments];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadComments];
}

-(NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.comments.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CommentCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CommentCollectionCell" forIndexPath:indexPath];
    cell.comment = self.comments[indexPath.item];
    return cell;
}

-(void)loadComments{
    //searching through parse to locase any objects that are comments
    PFQuery *query = [PFQuery queryWithClassName:@"Comment"];
    [query whereKey:@"venueName" equalTo:self.venue.name];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"user.name"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
        if ([comments count] != 0) {
            self.comments = comments;
            NSLog(@"loading the posts comments!");
            [self.collectionView reloadData];
        }
        else{
            NSLog(@"There are no comments on this post");
        }
    }];
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    self.header = nil;
    if( kind == UICollectionElementKindSectionHeader){
        self.header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"DetailsHeaderView" forIndexPath:indexPath];
        [self.header.venueImage setImageWithURL:self.venue.headerPicURL];
        self.header.nameLabel.text = self.venue.name;
        self.header.addressLabel.text = self.venue.streetAddress;
        [self.header.addressLabel sizeToFit];
        [self.header.nameLabel sizeToFit];
        PFQuery *query = [PFQuery queryWithClassName:@"Favorite"];
        query.limit = 1;
        [query whereKey:@"user" equalTo: PFUser.currentUser];
        [query whereKey:@"venueID" equalTo: self.venue.idStr];
        [query includeKeys:@[@"user", @"venueID"]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *favorite, NSError *error) {
            if ([favorite count] == 0) {
                [self.header setAnEmptyStar];
                self.favorited = NO;
            }
            else if(favorite) {
                [self.header setAFilledStar];
                self.favorited = YES;
            }
        }];
    }
    return self.header;
}

- (IBAction)didTapFavorite:(id)sender {
    if (self.favorited) {
        [Favorite removeVenue:(Venue * _Nullable)self.venue withCompletion:^(BOOL worked, NSError * _Nullable __strong error){
            if(error)
            {
                NSLog(@"favorite deletion did not work :( - %@", error.localizedDescription);
            }
            else{
                //do something by changing the value for the users propoerty for favorites
                [self.header setAnEmptyStar];
                self.favorited = NO;
                NSLog(@"favorite successfully deleted :D");
            }
        }];
    }
    else{
        [Favorite saveFavoritedVenue:self.venue withCompletion:^(BOOL worked, NSError * _Nullable __strong error){
            if(error)
            {
                NSLog(@"favorite addition did not work :( - %@", error.localizedDescription);
            }
            else{
                [self.header setAFilledStar];
                //add this venue to the users profile- add to the object
                self.favorited = YES;
                NSLog(@"favorite successfully added :D");
            }
        }];
    }
}

- (IBAction)didTapSpeech:(id)sender {
    if(!self.speech.isSpeaking){
        AVSpeechUtterance *specchuttternce=[[AVSpeechUtterance alloc] initWithString:self.venue.name];
        specchuttternce.rate=0.3;
        specchuttternce.voice=[AVSpeechSynthesisVoice voiceWithLanguage:@"en_GB"];
        self.speech=[[AVSpeechSynthesizer alloc] init];
        [self.speech speakUtterance:specchuttternce];
        
    }
}

- (IBAction)didTapReview:(id)sender {
    [self performSegueWithIdentifier:@"collectionReviewSegue" sender:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"collectionReviewSegue"]) {
        ReviewViewController *review = [segue destinationViewController];
        review.venue = self.venue;
    }

}


@end
