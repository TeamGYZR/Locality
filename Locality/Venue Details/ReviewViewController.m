//
//  ReviewViewController.m
//  Locality
//
//  Created by Ginger Dudley on 7/23/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "ReviewViewController.h"

@interface ReviewViewController ()

@property (weak, nonatomic) IBOutlet UITextField *commentTextField;
@property (strong, nonatomic) NSString *postedComment;

@end

@implementation ReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didTapPost:(id)sender {
    self.postedComment = self.commentTextField.text;
    [Comment saveVenueComment:self.venue withComment:self.postedComment withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(error)
        {
            NSLog(@"error adding comment - %@", error.localizedDescription);
        }
        else{
            NSLog(@"comment successfully added to parse");
        }
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
