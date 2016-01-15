//
//  BMCountryTableViewCell.h
//  Baker_MA_iOS
//
//  Created by Evgeny Dedovets on 7/8/15.
//  Copyright (c) 2015 Panda Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMBasicExpandableTableViewCell.h"
#import "BMCountry.h"

@interface BMCountryTableViewCell : BMBasicExpandableTableViewCell

@property (strong, nonatomic) BMCountry *country;
@property (weak, nonatomic) IBOutlet UILabel *countryTitle;
- (void) chooseCountry:(BOOL)chosen;

@end
