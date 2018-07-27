//
//  Path.h
//  Locality
//
//  Created by Ginger Dudley on 7/27/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "PFObject.h"
#import "Parse.h"

@interface Path : PFObject <PFSubclassing>

@property (strong, nonatomic) NSArray *coordinates;

@end
