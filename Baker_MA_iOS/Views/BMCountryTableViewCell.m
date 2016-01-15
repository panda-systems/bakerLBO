//
//  BMCountryTableViewCell.m
//  Baker_MA_iOS
//
//  Created by Evgeny Dedovets on 7/8/15.
//  Copyright (c) 2015 Panda Systems. All rights reserved.
//

#import "BMCountryTableViewCell.h"

@implementation BMCountryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void) chooseCountry:(BOOL)chosen{
    if (!chosen) {
        self.statusMarkView.image = [UIImage imageNamed:@"redMark"];
    } else {
        self.statusMarkView.image = [UIImage imageNamed:@"greenMark"];
    }
}

- (void)setCountry:(BMCountry *)country {
    _country = country;
    self.status = country.status;
}

- (void)markAsSeen{
    self.country.status = @"old";
    [super markAsSeen];
}

@end

