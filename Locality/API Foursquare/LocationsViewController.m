//
//  LocationsViewController.m
//  Locality
//
//  Created by Ginger Dudley on 7/16/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "LocationsViewController.h"
#import "LocationCell.h"

static NSString *const clientID = @"GCWUZIHYLK1DURPIEVO4HYRNIRUDC2NBKJHEPLE4RFMLQ35A";
static NSString *const clientSecret = @"VRCUJCWQYIWBFK212OOGGGU1KD2DKZLYVZZJ0ZUNEIBNA5EV";


//make this a table view in order to populate w info from the online webpage
@interface LocationsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//should the results be saved as a dictionary or in an array? decide this later when actually thinking about where and when to use the data taken from foursquare
@property (strong, nonatomic) NSArray *results;


@end

@implementation LocationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //sending in tester cooridnates
    [self testerCoordinates];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.results.count;
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationCell" forIndexPath:indexPath];
    //update the table view based on results from the response dictionary
    
    [cell updateCellWithLocation:self.results[indexPath.row]];
    
    return cell;
}

//tester function hard coded w the latitude and longitude to send to fetching the results
-(void) testerCoordinates{
    //NSNumber *testerLat = 40.7484;
    //NSNumber *testerLong = -73.9857;
    
    //new york  tester coordinates
    //NSNumber *testerLat = [NSNumber numberWithFloat:40.7484];
    //NSNumber *testerLong = [NSNumber numberWithFloat:-73.9857];
    
    //san francisco tester coordinates
    NSNumber *testerLat = [NSNumber numberWithFloat:37.7739];
    NSNumber *testerLong = [NSNumber numberWithFloat:-122.4313];
    
    [self fetchLocationsWithLatitude:testerLat andLongitude:testerLong];
    
}
//going to want to send a latitude and longitude into this from youngmin- send them as nsnumbers
-(void)fetchLocationsWithLatitude:(NSNumber *)lat andLongitude:(NSNumber *)longitude{
    NSString *baseURLstring = @"https://api.foursquare.com/v2/venues/explore?";
    //fix url- authentication failing
    
    //NSString *coordinateString = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&v=20141020&ll=%@,%@", clientID, clientSecret, lat, longitude];
    NSString *coordinateString = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&v=20180716&ll=%@,%@", clientID, clientSecret, lat, longitude];
    coordinateString = [coordinateString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:[baseURLstring stringByAppendingString:coordinateString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            //creating a dictionary to hold the json data
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            //printing out the json data to view the responses based on the specific coordinates
            //NSLog(@"response: %@", responseDictionary);
            //using the venue names as the query
            //probably gonna have to include the key for other info inside the results array
            self.results = [responseDictionary valueForKeyPath:@"response.groups.items.venue"][0];
            [self.tableView reloadData];
        }
    }];
    [task resume];
}

//fetching locations with the specific query - gonna have based on the latitude and longitude of the current location

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
