//
//  BMGeneralInquiryViewController.m
//  Baker_MA_iOS
//
//  Created by Panda Systems on 7/21/15.
//  Copyright (c) 2015 Panda Systems. All rights reserved.
//

#import "BMGeneralInquiryViewController.h"
#import "BMInquiryTableViewCell.h"
#import "BMQuestionTableViewCell.h"
#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>
#import "Baker_LBO_iOS-Swift.h"
#import "BMLoaderViewController.h"

@interface BMGeneralInquiryViewController () <UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong, nonatomic) NSMutableDictionary* cells;
@property (strong, nonatomic) BMLoaderViewController* loaderViewController;
@end

@implementation BMGeneralInquiryViewController {
    NSInteger activeRow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backButtonImage = [UIImage imageNamed:@"backArrow"];
    [button setBackgroundImage:backButtonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 33, 23);
    [button addTarget:self action:@selector(backButtonPushed:) forControlEvents:UIControlEventTouchDown];
    button.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.cells = [[NSMutableDictionary alloc] init];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    self.navigationItem.title = @"General Inquiry";
    
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([rootVC isKindOfClass:[UISplitViewController class]]) {
        self.navigationItem.leftBarButtonItem = nil;
    }
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:gestureRecognizer];
    [self registerForKeyboardNotifications];
    
    activeRow = -1;
}

- (void)hideKeyboard {
    [self.view endEditing:YES];
}

- (void)backButtonPushed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    activeRow = textField.tag;
    textField.attributedPlaceholder = nil;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    BMInquiryTableViewCell *cell = (BMInquiryTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag inSection:0]];
    [cell setPlaceholder:textField.tag delegate:self];
    activeRow = -1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row != 4 ? 52 :[UIScreen mainScreen].bounds.size.height - 347;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 18;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = self.cells[indexPath];
    if (cell) {
        return cell;
    }
    if(indexPath.row != 4) {
        
        BMInquiryTableViewCell* cell = (BMInquiryTableViewCell*)[[[NSBundle mainBundle] loadNibNamed:@"BMInquiryTableViewCell" owner:self options:nil] objectAtIndex:0];
        [cell setPlaceholder:indexPath.row delegate:self];
        [self.cells setObject:cell forKey:indexPath];
        return cell;

    } else {
        
        BMQuestionTableViewCell* cell = (BMQuestionTableViewCell*)[[[NSBundle mainBundle] loadNibNamed:@"BMQuestionTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.textView.delegate = self;
        [self.cells setObject:cell forKey:indexPath];
        return cell;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 18)];
    headerView.backgroundColor = [UIColor whiteColor];
    return headerView;
}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height - 57, 0.0);
    self.tableView.contentInset = contentInsets;

    self.tableView.scrollIndicatorInsets = contentInsets;
    if(activeRow == -1) {
        BMQuestionTableViewCell *cell = (BMQuestionTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
        [self.tableView scrollRectToVisible:cell.frame animated:NO];
    }
    if (activeRow == -1) {
        activeRow = 4;
    }
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:activeRow inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];

}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
}

- (void) startLoader{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    self.loaderViewController = [[BMLoaderViewController alloc] init];
    self.loaderViewController.view.alpha = 0.0;
    self.loaderViewController.view.frame = window.bounds;
    [window addSubview:self.loaderViewController.view];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.loaderViewController.view.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
}

- (void) dismissLoader{
    [self.loaderViewController.imageView stopAnimating];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.loaderViewController.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.loaderViewController.view removeFromSuperview];
    }];
}
- (IBAction)submitAction:(id)sender {
    
    NSString* urlString = [NSString stringWithFormat:@"http://67.205.60.227:81/api/add/question/"];
    NSIndexPath* ip1 = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath* ip2 = [NSIndexPath indexPathForRow:1 inSection:0];
    NSIndexPath* ip3 = [NSIndexPath indexPathForRow:2 inSection:0];
    NSIndexPath* ip4 = [NSIndexPath indexPathForRow:3 inSection:0];
    NSIndexPath* ip5 = [NSIndexPath indexPathForRow:4 inSection:0];

    NSString* text = ((BMQuestionTableViewCell*)self.cells[ip5]).textView.text;
    NSString* company = ((BMInquiryTableViewCell*)self.cells[ip4]).textField.text;
    NSString* email = ((BMInquiryTableViewCell*)self.cells[ip2]).textField.text;
    NSString* position = ((BMInquiryTableViewCell*)self.cells[ip3]).textField.text;
    NSString* author = ((BMInquiryTableViewCell*)self.cells[ip1]).textField.text;
    
    NSDictionary* params = @{@"text":text, @"company":company, @"email":email, @"position":position, @"author": author};
    
    [self startLoader];
    [[RKObjectManager sharedManager].HTTPClient postPath:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        JSSAlertViewResponder* responder = [[[JSSAlertView alloc] init] successOneButton:self.navigationController title:@"Success" text:@"Request submitted!"];
        [self dismissLoader];
        [responder addAction:^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self dismissLoader];
        if (error.userInfo[@"NSLocalizedRecoverySuggestion"]) {
            NSError *jsonError;
            NSData *objectData = [error.userInfo[@"NSLocalizedRecoverySuggestion"] dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
            if (json) {
                for (NSString* key in json) {
                    if ([json[key] isKindOfClass:[NSArray class]]) {
                        NSString* desc = [((NSArray*)json[key]) firstObject];
                        [[[JSSAlertView alloc] init] dangerOneButton:self.navigationController title:key text:desc];
                    }
                    break;
                }
            }
            else {
                [[[JSSAlertView alloc] init] dangerOneButton:self.navigationController title:@"Error" text:@"Network error"];
            }
        } else {
            [[[JSSAlertView alloc] init] dangerOneButton:self.navigationController title:@"Error" text:@"Network error"];
        }
    }];
}
@end
