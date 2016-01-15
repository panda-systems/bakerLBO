//
//  BMContactsViewController.h
//  Baker_MA_iOS
//
//  Created by Evgeny Dedovets on 7/16/15.
//  Copyright (c) 2015 Panda Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BMCountry;

@interface BMContactsViewController : UITableViewController
@property (nonatomic, strong) BMCountry* chosenCountry;

@end
