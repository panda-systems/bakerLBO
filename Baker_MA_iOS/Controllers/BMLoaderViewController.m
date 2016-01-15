//
//  BMLoaderViewController.m
//  Baker_MA_iOS
//
//  Created by Panda Systems on 7/27/15.
//  Copyright (c) 2015 Panda Systems. All rights reserved.
//

#import "BMLoaderViewController.h"

@interface BMLoaderViewController ()

@end

@implementation BMLoaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.imageView.animationImages = @[
                                       [UIImage imageNamed:@"01"],
                                       [UIImage imageNamed:@"02"],
                                       [UIImage imageNamed:@"03"],
                                       [UIImage imageNamed:@"04"],
                                       [UIImage imageNamed:@"05"],
                                       [UIImage imageNamed:@"06"],
                                       [UIImage imageNamed:@"07"],
                                       [UIImage imageNamed:@"08"],
                                       [UIImage imageNamed:@"09"],
                                       [UIImage imageNamed:@"10"],
                                       [UIImage imageNamed:@"11"],
                                       [UIImage imageNamed:@"12"],
                                       ];
    self.imageView.animationDuration = 1.5;
    [self.imageView startAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
