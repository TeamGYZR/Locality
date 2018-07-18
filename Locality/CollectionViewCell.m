//
//  CollectionViewCell.m
//  Locality
//
//  Created by Zelalem Tenaw Terefe on 7/18/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "CollectionViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation CollectionViewCell
-(void) setdata{
    
    
    [self.imagefiled setImageWithURL:self.url];
    
    
}




@end
