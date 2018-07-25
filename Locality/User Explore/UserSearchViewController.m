//
//  UserSearchViewController.m
//  Locality
//
//  Created by Ginger Dudley on 7/25/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "UserSearchViewController.h"
#import "UserCell.h"

@interface UserSearchViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *users;


@end

@implementation UserSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self loadUsers];
    
}

-(void)loadUsers{
    PFQuery *query = [PFUser query];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"user.name"];
    self.users = [query findObjects];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.users.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
    cell.user = self.users[indexPath.row];
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
