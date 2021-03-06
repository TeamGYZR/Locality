//
//  DetailsViewController.m
//  Locality
//
//  Created by Ginger Dudley on 7/17/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "DetailsViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "UIImageView+AFNetworking.h"
#import "DetailsCollectionViewController.h"

//testing out parse user stuff
#import "Parse.h"

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *venueImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;


//adding this to test out button image replacement
@property (nonatomic) BOOL favorited;



@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.venueImage setImageWithURL:self.venue.headerPicURL];
    self.nameLabel.text = self.venue.name;
    self.addressLabel.text = self.venue.streetAddress;
    [self.addressLabel sizeToFit];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Favorite"];
    query.limit = 1; 
    [query whereKey:@"user" equalTo: PFUser.currentUser];
    [query whereKey:@"venueName" equalTo: self.venue.name];
    
    [query includeKeys:@[@"user", @"venueID"]];
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *favorite, NSError *error) {
        if ([favorite count] == 0) {
            [self setAnEmptyStar];
            self.favorited = NO;
        } else if(favorite) {
            [self setAFilledStar];
            self.favorited = YES;
        }
    }];
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)didTapFavorite:(id)sender {
    
//    //if user has icon favorited- create a boolean to hold this
    if (self.favorited) {
        [Favorite removeVenue:(Venue * _Nullable)self.venue withCompletion:^(BOOL worked, NSError * _Nullable __strong error){
            if(error)
            {
                NSLog(@"favorite deletion did not work :( - %@", error.localizedDescription);
            }
            else{
                //do something by changing the value for the users propoerty for favorites
                [self setAnEmptyStar];
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
                [self setAFilledStar];
                //add this venue to the users profile- add to the object
                self.favorited = YES;
                NSLog(@"favorite successfully added :D");
            }
            
        }];

    }
    
    
    
}

-(void)setAFilledStar{
    UIImage *favoriteButtonImage = [UIImage imageNamed:@"star"];
    [self.favoriteButton setImage:favoriteButtonImage forState:UIControlStateNormal];
}

-(void)setAnEmptyStar{
    UIImage *unfavoriteButtonImage = [UIImage imageNamed:@"emptyStar"];
    [self.favoriteButton setImage:unfavoriteButtonImage forState:UIControlStateNormal];
}

- (IBAction)soundbutton:(id)sender {
    if(!self.speech.isSpeaking){
        AVSpeechUtterance *specchuttternce=[[AVSpeechUtterance alloc] initWithString:self.venue.name];
        specchuttternce.rate=0.5;
        specchuttternce.voice=[AVSpeechSynthesisVoice voiceWithLanguage:@"en_GB"];
        self.speech=[[AVSpeechSynthesizer alloc] init];
        [self.speech speakUtterance:specchuttternce];
        
    }
}


- (IBAction)didTapReview:(id)sender {
    [self performSegueWithIdentifier:@"reviewSegue" sender:nil];    
}

- (IBAction)didTapCollectionView:(id)sender {
    [self performSegueWithIdentifier:@"collectionReviewSegue" sender:nil];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"reviewSegue"]) {
        ReviewViewController *review = [segue destinationViewController];
        review.venue = self.venue;
    }
    else if ([segue.identifier isEqualToString:@"collectionReviewSegue"]){
        DetailsCollectionViewController *detailVC = [segue destinationViewController];
        detailVC.venue = self.venue;
        
    }
    
}


@end
