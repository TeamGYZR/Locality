//
//  CollectionViewCell.h
//  Locality
//
//  Created by Zelalem Tenaw Terefe on 7/18/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imagefiled;
-(void) setdata;
@property (strong, nonatomic) NSURL * url;
@end
