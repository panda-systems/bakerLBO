//
//  BMQuestionTableViewCell.m
//  Baker_MA_iOS
//
//  Created by Panda Systems on 7/21/15.
//  Copyright (c) 2015 Panda Systems. All rights reserved.
//

#import "BMQuestionTableViewCell.h"

@implementation BMQuestionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if([UIScreen mainScreen].bounds.size.width == 414) {
        self.textView.layer.borderWidth = 0.33;
    } else {
        self.textView.layer.borderWidth = 0.5;
    }
    self.textView.layer.borderColor = [[UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0] CGColor];
}

@end
