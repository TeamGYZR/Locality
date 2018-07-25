//
//  ResultsViewCell.h
//  Locality
//
//  Created by Youngmin Shin on 7/24/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ResultsViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) MKMapItem * result; 

@end
