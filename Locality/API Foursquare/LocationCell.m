//
//  LocationCell.m
//  Locality
//
//  Created by Ginger Dudley on 7/16/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "LocationCell.h"

//adding an interface to link up the table view
@interface LocationCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) NSDictionary *location;

@end

@implementation LocationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//-(void)updateCellWithLocation:(NSArray *)location{
//    //self.nameLabel.text = location[@"name"];
//    //NSLog(@"%@", location[@"venue.name"]);
//    //trying to access the name inside this locations dictionary
//    //NSLog(@"%@", location[@"venue"]);
//    //self.location = location[0];
//    //NSArray *testerArray = location[@"0"][@"name"];
//    //self.nameLabel.text = testerArray[@"name"];
//    //NSDictionary *firstLocation = location;
////    NSLog(@"%@", firstLocation[@"name"]);
////    self.nameLabel.text = firstLocation[@"name"];
//
//    //NSLog(@"%@", location[@"name"]);
//    //self.nameLabel.text = location[@"name"];
//
//}

-(void)updateCellWithLocation:(NSDictionary *)location{
    //self.nameLabel.text = location[@"name"];
    //NSLog(@"%@", location[@"venue.name"]);
    //trying to access the name inside this locations dictionary
    //NSLog(@"%@", location[@"venue"]);
    //self.location = location[0];
    //NSArray *testerArray = location[@"0"][@"name"];
    //self.nameLabel.text = testerArray[@"name"];
    //NSDictionary *firstLocation = location;
    //    NSLog(@"%@", firstLocation[@"name"]);
    //    self.nameLabel.text = firstLocation[@"name"];
    
    //NSLog(@"%@", location[@"name"]);
    self.nameLabel.text = location[@"name"];
    
}

@end
