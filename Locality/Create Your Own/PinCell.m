//
//  PinCell.m
//  Locality
//
//  Created by Ginger Dudley on 7/31/18.
//  Copyright © 2018 Ginger Dudley. All rights reserved.
//

#import "PinCell.h"

@interface PinCell () <UITextFieldDelegate>
@end

@implementation PinCell

- (void)setDelegate:(id<UITextFieldDelegate>)delegate{
    _delegate = delegate;
    self.nameTextField.delegate = delegate;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.nameChange = self.nameTextField.text;
    [self.pinDelegate textNameDidChange:self];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.nameTextField.text = @"";
}

@end
