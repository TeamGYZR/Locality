//
//  ResultsViewCell.m
//  Locality
//
//  Created by Youngmin Shin on 7/24/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "ResultsViewCell.h"

@implementation ResultsViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setResult:(MKMapItem *)result{
    _result = result;
    
    self.nameLabel.text = result.name; 
    
}

@end
