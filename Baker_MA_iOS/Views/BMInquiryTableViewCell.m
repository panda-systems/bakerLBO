//
//  BMInquiryTableViewCell.m
//  Baker_MA_iOS
//
//  Created by Panda Systems on 7/21/15.
//  Copyright (c) 2015 Panda Systems. All rights reserved.
//

#import "BMInquiryTableViewCell.h"

@implementation BMInquiryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if([UIScreen mainScreen].bounds.size.width == 414) {
        self.separatorHeight.constant = 0.33;
    } else {
        self.separatorHeight.constant = 0.5;
    }
    UIColor *placeholderColor = [UIColor colorWithRed:95.0/255.0 green:95.0/255.0 blue:95.0/255.0 alpha:1.0];
    self.textField.attributedText =
    [[NSAttributedString alloc] initWithString:@""
                                    attributes:@{
                                                 NSForegroundColorAttributeName: placeholderColor,
                                                 NSFontAttributeName : [UIFont fontWithName:@"Roboto-Light" size:18.0]
                                                 }
     ];
}

- (void)setPlaceholder:(NSInteger)index delegate:(id)delegate {
    NSString *placeholderText = [NSString string];
    UIColor *placeholderColor = [UIColor colorWithRed:95.0/255.0 green:95.0/255.0 blue:95.0/255.0 alpha:1.0];

    switch (index) {
        case 0:
            placeholderText = @"Name";
            break;
        case 1:
            placeholderText = @"E-mail";
            break;
        case 2:
            placeholderText = @"Position";
            break;
        case 3:
            placeholderText = @"Organization";
            break;
            
        default:
            break;
    }
    self.textField.tag = index;
    self.textField.delegate = delegate;
    self.textField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:placeholderText
                                    attributes:@{
                                                 NSForegroundColorAttributeName: placeholderColor,
                                                 NSFontAttributeName : [UIFont fontWithName:@"Roboto-Light" size:18.0]
                                                 }
     ];
    
}

@end
