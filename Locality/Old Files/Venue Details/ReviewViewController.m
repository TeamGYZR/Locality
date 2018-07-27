//
//  ReviewViewController.m
//  Locality
//
//  Created by Ginger Dudley on 7/23/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "ReviewViewController.h"
#import "CommentCell.h"
#import "APImanager.h"

@interface ReviewViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *commentTextField;
@property (strong, nonatomic) NSString *postedComment;
@property (strong, nonatomic) NSArray *comments;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property APIManager *apiManager;


@end

@implementation ReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.apiManager = [APIManager new];
    [self loadComments];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
}

-(void)loadComments{
    //searching through parse to locase any objects that are comments
    PFQuery *query = [PFQuery queryWithClassName:@"Comment"];
    [query whereKey:@"venueName" equalTo:self.venue.name];
    //trying to save the user info in the query
    [query includeKey:@"user.name"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
        if ([comments count] != 0) {
            self.comments = comments;
            [self.tableView reloadData];
        }else{
            NSLog(@"There are no comments on this post");
        }
    }];
}

- (IBAction)didTapPost:(id)sender {
    self.postedComment = self.commentTextField.text;
    [Comment saveVenueComment:self.venue withComment:self.postedComment withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error adding comment - %@", error.localizedDescription);
        } else {
            NSLog(@"comment successfully added to parse");
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }];
}
- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section{
    return self.comments.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    cell.comment = self.comments[indexPath.row];
    return cell;
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
