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

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *venueImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;


//adding this to test out button image replacement
@property (nonatomic) BOOL *favorited;



@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //view is passed in a specific venue from the photo controller, grid view controller sends over one object w all the info
    
    //maybe the grid view controller can add the first picture to the venue object? as a url
    //then send over this info and display the image attatched to the specific url
    
    //display the specific venue info here- do we want to add in another api? maye=be youngmin could do this to get phone number/ main pic
    
    
//    [self.venueImage setImageWithURL:self.venue.headerPicURL];
//    self.nameLabel.text = self.venue.name;
//    self.addressLabel.text = self.venue.streetAddress;
    
    //set initial favorite button based on users boolean value for the favorite icon
    //NO -- emptyStar
    //YES -- star
//    if (favorited) {
    //        [self setAnEmptyStar];
    //
//    }
//    else{
    //        [self setAFilledStar];
//    }
    
    self.favorited = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)didTapFavorite:(id)sender {
    
//    //if user has icon favorited- create a boolean to hold this
    if (self.favorited) {
        [self setAnEmptyStar];
        self.favorited = NO;
        //do something by changing the value for the users propoerty for favorites
    }
    else{
        [self setAFilledStar];
        //add this venue to the users profile- add to the object
        self.favorited = YES;
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
