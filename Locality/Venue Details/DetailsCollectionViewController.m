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

@interface DetailsCollectionViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *comments;
@property APIManager *apiManager;

@end

@implementation DetailsCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.apiManager = [APIManager new];
    
    [self loadComments];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    


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
    [query includeKey:@"user.name"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
        if ([comments count] != 0) {
            self.comments = comments;
            [self.collectionView reloadData];
        }
        else{
            NSLog(@"There are no comments on this post");
        }
    }];
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    DetailsHeaderView *header = nil;
    if( kind == UICollectionElementKindSectionHeader){
        header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"DetailsHeaderView" forIndexPath:indexPath];
        
        //set up header view based on how the original deails view controller is set up
    }
    
    return header;
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
