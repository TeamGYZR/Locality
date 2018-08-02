//
//  PathFinalizationViewController.m
//  Locality
//
//  Created by Ginger Dudley on 7/30/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "PathFinalizationViewController.h"
#import "LCMapView.h"
#import "CreateYourOwnViewController.h"
#import "PinCell.h"

@interface PathFinalizationViewController () <UITableViewDelegate, UITableViewDataSource, PinCellDelegate>
@property (weak, nonatomic) IBOutlet UITextField *itineraryTitle;
@property (weak, nonatomic) IBOutlet UITextField *itineraryDescription;
@property (weak, nonatomic) IBOutlet UISegmentedControl *categoryController;
@property (weak, nonatomic) IBOutlet LCMapView *LCMapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *createYourOwnView;
@property (weak, nonatomic) IBOutlet UIButton *upButton;

@end

@implementation PathFinalizationViewController

#pragma mark - View Controller
- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.LCMapView configureWithItinerary:self.itinerary isStatic:NO];
}

#pragma mark - Private Methods

- (void)dismissKeyboard{
    [self.itineraryTitle resignFirstResponder];
    [self.itineraryDescription resignFirstResponder];
}

- (void)textNameDidChange:(PinCell *)passedCell{

    int cellIndex = [passedCell.pinIndex intValue];
    [self.itinerary.pinnedLocations[cellIndex] setObject:passedCell.nameChange forKey:@"name"];
}

- (void)userTappedTextField{
    [UIView animateWithDuration:0.4 animations:^{
        [self.LCMapView setFrame:CGRectMake(0, 0, self.createYourOwnView.bounds.size.width, self.LCMapView.bounds.size.height)];
        [self.tableView setFrame:CGRectMake(0, self.LCMapView.bounds.size.height, self.tableView.bounds.size.width, 135)];
        [self.upButton setFrame:CGRectMake(174, 0, 44, 44)];
    }];
}

#pragma mark - IBActions

- (IBAction)didTapPost:(id)sender {
    self.itinerary.name = self.itineraryTitle.text;
    self.itinerary.pathDescription = self.itineraryDescription.text;
    NSArray *categories = @[@"Foodie", @"Entertainment", @"Nature"];
    self.itinerary.category = categories[self.categoryController.selectedSegmentIndex];
    [self.tableView reloadData];
    [self.itinerary setObject:self.itinerary.pinnedLocations forKey:@"pinnedLocations"];
    [self.itinerary saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error saving Path info to Parse");
        } else{
            NSLog(@"Successfulyy saved path to Parse");
            [self performSegueWithIdentifier:@"cyoToHomeSegue" sender:nil];
        }
    }];
}

- (IBAction)didTapBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (IBAction)didTapUpButton:(id)sender {
    [UIView animateWithDuration:0.4 animations:^{
        [self.LCMapView setFrame:CGRectMake(0, 138, self.createYourOwnView.bounds.size.width, self.LCMapView.bounds.size.height)];
        [self.tableView setFrame:CGRectMake(0, 374, self.tableView.bounds.size.width, 229)];
        [self.upButton setFrame:CGRectMake(175, -41, 44, 44)];
        [self.view endEditing:YES];
    }];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itinerary.pinnedLocations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PinCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PinCell" forIndexPath:indexPath];
    cell.pinNumberLabel.text = [[NSNumber numberWithInt:(indexPath.row+1)] stringValue];
    cell.pinIndex = [NSNumber numberWithInt:(indexPath.row)];
    if (self.itinerary.pinnedLocations[indexPath.row][@"name"]) {
        cell.nameTextField.text = self.itinerary.pinnedLocations[indexPath.row][@"name"];
    }
    cell.pinDelegate = self;
    cell.nameTextField.delegate = cell;

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
