//
//  PathFinalizationViewController.m
//  Locality
//
//  Created by Ginger Dudley on 7/30/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "PathFinalizationViewController.h"

@interface PathFinalizationViewController ()
@property (weak, nonatomic) IBOutlet UITextField *itineraryTitle;
@property (weak, nonatomic) IBOutlet UITextField *itineraryDescription;
@property (weak, nonatomic) IBOutlet UISegmentedControl *categoryController;

@end

@implementation PathFinalizationViewController

#pragma mark - View Controller
- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
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
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    }];
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
