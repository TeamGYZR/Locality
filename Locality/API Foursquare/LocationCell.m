//
//  LocationCell.m
//  Locality
//
//  Created by Ginger Dudley on 7/16/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "LocationCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

//adding an interface to link up the table view
@interface LocationCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) NSDictionary *location;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *categoryIcon;

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


-(void)updateCellWithLocation:(NSDictionary *)location{


    
    //NSLog(@"%@", location[@"name"]);
    self.nameLabel.text = location[@"name"];
    //NSLog(@"%@", location[@"location"][@"formattedAddress"][0]);
    self.addressLabel.text = location[@"location"][@"formattedAddress"][0];
    //conditional to check if the categories exist
//    if () {
//         NSString *prefix =
//    }
    self.categoryLabel.text = location[@"categories"][0][@"name"];
    NSString *urlPrefix = location[@"categories"][0][@"icon"][@"prefix"];
    NSString *urlSuffix = location[@"categories"][0][@"icon"][@"suffix"];
    NSString *urlString = [NSString stringWithFormat:@"%@bg_32%@", urlPrefix, urlSuffix];
    
    NSURL *url = [NSURL URLWithString:urlString];
    [self.categoryIcon setImageWithURL:url];
    
}

@end
