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

@interface PathFinalizationViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *itineraryTitle;
@property (weak, nonatomic) IBOutlet UITextField *itineraryDescription;
@property (weak, nonatomic) IBOutlet UISegmentedControl *categoryController;
@property (weak, nonatomic) IBOutlet LCMapView *LCMapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation PathFinalizationViewController

#pragma mark - View Controller
- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.LCMapView initWithItinerary:self.itinerary isStatic:NO];
}

#pragma mark - Private Methods

- (void)dismissKeyboard{
    [self.itineraryTitle resignFirstResponder];
    [self.itineraryDescription resignFirstResponder];
}

#pragma mark - IBActions

- (IBAction)didTapPost:(id)sender {
    self.itinerary.name = self.itineraryTitle.text;
    self.itinerary.pathDescription = self.itineraryDescription.text;
    NSArray *categories = @[@"Foodie", @"Entertainment", @"Nature"];
    self.itinerary.category = categories[self.categoryController.selectedSegmentIndex];
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

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itinerary.pinnedLocations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PinCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PinCell" forIndexPath:indexPath];
    cell.pinNumberLabel.text = [[NSNumber numberWithInt:(indexPath.row+1)] stringValue];
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
