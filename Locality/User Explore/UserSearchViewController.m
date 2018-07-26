//
//  UserSearchViewController.m
//  Locality
//
//  Created by Ginger Dudley on 7/25/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "UserSearchViewController.h"
#import "UserCell.h"
#import "ProfileViewController.h"

@interface UserSearchViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *users;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *unfilteredUsers;
@end

@implementation UserSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    [self loadUsers];
}

- (void)loadUsers{
    PFQuery *query = [PFUser query];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"user.name"];
    self.users = [query findObjects];
    self.unfilteredUsers = self.users;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.users.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
    cell.user = self.users[indexPath.row];
    return cell;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length != 0) {
        self.users = [self.users filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(username contains[c] %@)", searchText]];
        [self.tableView reloadData];
    }
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    self.searchBar.showsCancelButton = YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    self.users = self.unfilteredUsers;
    [self.tableView reloadData];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([sender isKindOfClass:[UserCell class]]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        User *user = self.users[indexPath.row];
        ProfileViewController *profileViewController = [segue destinationViewController];
        profileViewController.user = user;
    }
}


@end
