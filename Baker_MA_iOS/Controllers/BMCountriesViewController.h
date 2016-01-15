//
//  BMCountriesViewController.h
//  Baker_MA_iOS
//
//  Created by Panda Systems on 7/22/15.
//  Copyright (c) 2015 Panda Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BMCountry;

@protocol BMCountriesViewControllerDelegate <NSObject>

-(void)didChooseCountry:(BMCountry*)country;

@end


@interface BMCountriesViewController : UIViewController
@property(nonatomic, strong) NSMutableArray* countries;
@property(nonatomic, weak) id<BMCountriesViewControllerDelegate> delegate;
@property (nonatomic, strong) BMCountry* chosenCountry;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) BOOL haveContainerView;

@end
