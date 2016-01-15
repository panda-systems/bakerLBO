//
//  BMInquiryTableViewCell.h
//  Baker_MA_iOS
//
//  Created by Panda Systems on 7/21/15.
//  Copyright (c) 2015 Panda Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMInquiryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *separatorHeight;

- (void)setPlaceholder:(NSInteger)index delegate:(id)delegate;

@end
