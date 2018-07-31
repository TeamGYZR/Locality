//
//  LCPathDetailViewController.m
//  Locality
//
//  Created by Youngmin Shin on 7/30/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "LCPathDetailViewController.h"
#import "LCMapView.h"

@interface LCPathDetailViewController ()
@property (weak, nonatomic) IBOutlet LCMapView *lcMapView;


@end

@implementation LCPathDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.lcMapView initWithItinerary:self.itinerary isStatic:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)mapViewType{
    return self;
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
