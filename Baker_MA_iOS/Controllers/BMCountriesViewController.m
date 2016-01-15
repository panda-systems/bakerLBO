//
//  BMCountriesViewController.m
//  Baker_MA_iOS
//
//  Created by Panda Systems on 7/22/15.
//  Copyright (c) 2015 Panda Systems. All rights reserved.
//

#import "BMCountriesViewController.h"
#import "BMCountryTableViewCell.h"
#import "BMCountry.h"
#import "BMContactsViewController.h"

@interface BMCountriesViewController ()

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *customNavBarHeightConstraint;

@end

@implementation BMCountriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    [self.tableView registerNib:[UINib nibWithNibName:@"BMCountryTableViewCell" bundle:nil] forCellReuseIdentifier:@"countryTableViewCell"];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    [self setupNavigationBar];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupNavigationBar {
    if (self.haveContainerView) {
        self.customNavBarHeightConstraint.constant = 64.f;
    } else {
        self.customNavBarHeightConstraint.constant = 0;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *backButtonImage = [UIImage imageNamed:@"backArrow"];
        [button setBackgroundImage:backButtonImage forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, 33, 23);
        [button addTarget:self action:@selector(backButtonPushed:) forControlEvents:UIControlEventTouchDown];
        button.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = barButtonItem;
        
        self.navigationItem.title = @"Select Country";
    }
}

- (void)backButtonPushed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.countries.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BMCountryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"countryTableViewCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.countryTitle.text = @"All countries";
        if (!self.chosenCountry && self.haveContainerView) {
            [cell chooseCountry:YES];
        } else {
            [cell chooseCountry:NO];
        }
        
    } else {
        BMCountry* country = (BMCountry*)self.countries[indexPath.row-1];
        cell.countryTitle.text = country.name;
        // Configure the cell...
        if (self.chosenCountry && [self.chosenCountry.countryId isEqualToNumber:country.countryId]) {
            [cell chooseCountry:YES];
        } else {
            [cell chooseCountry:NO];
        }
    }
    cell.titleView.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate) {
        if (indexPath.row == 0) {
            [self.delegate didChooseCountry:nil];
        } else {
            [self.delegate didChooseCountry:self.countries[indexPath.row-1]];
        }
    }
    else if (!self.haveContainerView) {
        BMContactsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BMContactsViewController"];
        if (indexPath.row == 0) {
            vc.chosenCountry = nil;
        }
        else {
            vc.chosenCountry = self.countries[indexPath.row-1];
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
