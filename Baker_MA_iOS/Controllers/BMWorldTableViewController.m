//
//  BMContactsTableViewController.m
//  Baker_MA_iOS
//
//  Created by Evgeny Dedovets on 7/1/15.
//  Copyright (c) 2015 Panda Systems. All rights reserved.
//

#import "BMWorldTableViewController.h"
#import "SLExpandableTableView.h"
#import "BMCountryTableViewCell.h"
#import "BMTopicTableViewCell.h"
#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>
#import "BMCountry.h"
#import "BMSubject.h"
#import "BMSubTopic.h"
#import "BMTopic.h"
#import "BMInitData.h"
#import "BMExpandDescriptionSegue.h"
#import "Baker_LBO_iOS-Swift.h"

@interface BMWorldTableViewController () <SLExpandableTableViewDatasource, SLExpandableTableViewDelegate, BMTopicTableViewCellDelegate>


@property (nonatomic, strong) NSMutableArray                       *countries;
@property (nonatomic, strong) NSArray                       *firstSectionStrings;
@property (nonatomic, strong) NSArray                       *secondSectionStrings;
@property (nonatomic, strong) NSMutableArray                *sectionsArray;
@property (nonatomic, strong) NSIndexPath                   *lastSelectedTopicIndexPath;
@property (nonatomic, assign) int                           lastExpandedSection;
@property (nonatomic, assign) CGFloat                       lastSelectedTopicExpandbleHeight;
@property (nonatomic, assign) BMExpandableSelectionLevel    currSelectionLevel;
@property (nonatomic, assign) CGPoint                       centerForExpansion;
@property (nonatomic, assign) NSString                      *selectedDescription;
@property (nonatomic, assign) NSString                      *selectedTitle;
@property (nonatomic)         BOOL                          needsUpdateData;
@property (nonatomic, strong) NSManagedObjectContext        *context;
@end


@implementation BMWorldTableViewController


#pragma mark - Memory management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad{
    //self.centerForExpansion = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);
    self.lastExpandedSection = -1;
    self.context = [RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"BMInitData"];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    fetchRequest.sortDescriptors = @[descriptor];
    NSError *error = nil;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    BMInitData *allData = [fetchedObjects firstObject];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    self.countries = [[[allData.countries allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]] mutableCopy];
    
    [self cleanInitData];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backButtonImage = [UIImage imageNamed:@"backArrow"];
    [button setBackgroundImage:backButtonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 32, 23);
    [button addTarget:self action:@selector(backButtonPushed:) forControlEvents:UIControlEventTouchDown];
    button.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([rootVC isKindOfClass:[UISplitViewController class]]) {
        self.navigationItem.leftBarButtonItem = nil;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataUpdated:) name:@"BMDataUpdated" object:nil];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"expandDescription"]) {
        ((BMExpandDescriptionSegue *)segue).destinationCenter = self.centerForExpansion;
        ((BMExpandDescriptionSegue *)segue).selectedDescription = self.selectedDescription;
        ((BMExpandDescriptionSegue *)segue).selectedTitle = self.selectedTitle;
    }
}

-(void) backButtonPushed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)fetchArticlesFromContext {
    
}

- (void)loadView{
    self.tableView = [[SLExpandableTableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)cleanInitData {
    for (int i = (int)self.countries.count - 1; i >= 0; i--) {
        BMCountry *country = self.countries[i];
        if ([country.status isEqualToString:@"del"])
            [self.countries removeObject:country];
        else {
            NSMutableArray *topics = [[country.topics allObjects] mutableCopy];
            for (int i = (int)topics.count - 1; i >= 0; i--) {
                BMTopic *topic = topics[i];
                if ([topic.status isEqualToString:@"del"])
                    [topics removeObject:topic];
                else {
                    NSMutableArray *subTopics = [[topic.subtopics allObjects] mutableCopy];
                    for (int i = (int)subTopics.count - 1; i >= 0; i--) {
                        BMSubTopic *subTopic = subTopics[i];
                        if ([subTopic.status isEqualToString:@"del"])
                            [subTopics removeObject:subTopic];
                        else {
                            NSMutableArray *subjects = [[subTopic.subjects allObjects] mutableCopy];
                            for (int i = (int)subjects.count - 1; i >= 0; i--) {
                                BMSubject *subject = subjects[i];
                                if ([subject.status isEqualToString:@"del"])
                                    [subjects removeObject:subject];
                                if (i == 0) {
                                    subTopic.subjects = [NSSet setWithArray:subjects];
                                }
                            }
                        }
                        if (i == 0) {
                            topic.subtopics = [NSSet setWithArray:subTopics];
                        }
                    }
                }
                if (i == 0) {
                    country.topics = [NSSet setWithArray:topics];
                }
            }
        }
    }
}

#pragma mark - SLExpandableTableViewDelegate

- (void)shouldUpdateSizeAtIndexPath:(NSIndexPath*)indexPath andChildUIExpansionStyle:(UIExpansionStyle)style andSelectionLevel:(BMExpandableSelectionLevel)selectionLevel{
    [self.tableView beginUpdates];
    if (self.lastSelectedTopicIndexPath) {
        BMTopicTableViewCell *cell = (BMTopicTableViewCell*) [self.tableView cellForRowAtIndexPath:self.lastSelectedTopicIndexPath];
        if (selectionLevel == BMExpandbleSelectionSubTopic) {
            if (!cell.descriptionHidden) {
                [cell setDescriptionHidden:YES];
                [cell select:NO];
                NSUInteger subTopicsCount = [cell.topic.subtopics count];
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
                BMSubTopic *lastSelectedSubTopic = [[[cell.topic.subtopics allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]] objectAtIndex:cell.lastExpandedSection];
                NSUInteger subjectsCount = [lastSelectedSubTopic.subjects  count];
                self.lastSelectedTopicExpandbleHeight = subTopicsCount*48 + subjectsCount*48 + 132 +48;
            }
        } else {
            if (selectionLevel != BMExpandbleSelectionCoutry) {
                [cell setDescriptionHidden:NO];
                [cell select:YES];
                self.lastSelectedTopicExpandbleHeight = 180 + [cell.topic.subtopics count]*48;
            }
        }
        self.currSelectionLevel = selectionLevel;
    }
    [self.tableView endUpdates];
}

- (void)shouldPerformSegue:(CGPoint)center withSender:(id)sender description:(NSString *)description andtitle:(NSString *)title{
    
    self.centerForExpansion = CGPointMake(center.x, center.y - self.tableView.contentOffset.y + 48 + 66 + 66);
    self.selectedDescription = description;
    self.selectedTitle = title;
    
    [self performSegueWithIdentifier:@"expandDescription" sender:self];
    
}
#pragma mark - SLExpandableTableViewDatasource

- (BOOL)tableView:(SLExpandableTableView *)tableView needsToDownloadDataForExpandableSection:(NSInteger)section {
    return NO;
}

- (BOOL)tableView:(SLExpandableTableView *)tableView canExpandSection:(NSInteger)section {
    return YES;
}


- (UITableViewCell<UIExpandingTableViewCell> *)tableView:(SLExpandableTableView *)tableView expandingCellForSection:(NSInteger)section {
    static NSString *CellIdentifier = @"countryTableViewCell";
    BMCountryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = (BMCountryTableViewCell*)[[[NSBundle mainBundle] loadNibNamed:@"BMCountryTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    BMCountry *country = (BMCountry*)[self.countries objectAtIndex:section];
    cell.country = country;
    cell.countryTitle.text = country.name;
    cell.context = self.context;
    return cell;
}

#pragma mark - SLExpandableTableViewDelegate

- (void)tableView:(SLExpandableTableView *)tableView downloadDataForExpandableSection:(NSInteger)section {

}

- (void)tableView:(SLExpandableTableView *)tableView willCollapseSection:(NSUInteger)section animated:(BOOL)animated {
    BMCountryTableViewCell *cell = (BMCountryTableViewCell*)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    [cell select:NO];
    self.currSelectionLevel = BMExpandbleSelectionCoutry;
    self.lastSelectedTopicIndexPath = nil;
    self.lastExpandedSection = -1;
}

- (void)tableView:(SLExpandableTableView *)tableView didCollapseSection:(NSUInteger)section animated:(BOOL)animated {
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.lastSelectedTopicIndexPath isEqual:indexPath]) {
        return self.lastSelectedTopicExpandbleHeight;
    }
    return 48;
}

- (void)tableView:(SLExpandableTableView *)tableView willExpandSection:(NSUInteger)section animated:(BOOL)animated {
    if (self.lastExpandedSection > -1) {
        [tableView collapseSection:(NSUInteger)self.lastExpandedSection animated:YES];
    }
    self.lastExpandedSection = (int)section;
}

- (void)tableView:(SLExpandableTableView *)tableView didExpandSection:(NSUInteger)section animated:(BOOL)animated {
    BMCountryTableViewCell *cell = (BMCountryTableViewCell*)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    [cell select:YES];

}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.countries count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    BMCountry *country = (BMCountry*)[self.countries objectAtIndex:section];
    return [country.topics count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"topicTableViewCell";
    BMTopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = (BMTopicTableViewCell*)[[[NSBundle mainBundle] loadNibNamed:@"BMTopicTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.topicTableViewCellDelegate = self;
    BMCountry *country = (BMCountry*)[self.countries objectAtIndex:indexPath.section];
    //NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    //    cell.topic = [[[country.topics allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]] objectAtIndex:indexPath.row - 1];
    cell.topic = [[[country.topics allObjects] sortedArrayUsingFunction:&sort context:@"title"] objectAtIndex:indexPath.row - 1];
    
    
    cell.topicTitle.text = cell.topic.title;
    cell.topLevelDescription.text = country.name;
    cell.context = self.context;
    return cell;
}

NSInteger sort(id a, id b, void* p) {
    return [[a valueForKey:(__bridge NSString*)p]
            compare:[b valueForKey:(__bridge NSString*)p]
            options:NSNumericSearch];
}

#pragma mark - UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        return 20;
//    }
//    return 0;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath isEqual:self.lastSelectedTopicIndexPath]) {
        BMTopicTableViewCell *prevSelectetTopicCell = (BMTopicTableViewCell*) [tableView cellForRowAtIndexPath:self.lastSelectedTopicIndexPath];
        self.lastSelectedTopicIndexPath = nil;
//        [UIView animateWithDuration:0.3f animations:^{
//            [prevSelectetTopicCell select:YES];
//        } completion:^(BOOL finished) {
            [prevSelectetTopicCell collapseTopic];
            [prevSelectetTopicCell select:NO];
            [prevSelectetTopicCell setDescriptionHidden:YES];
            [prevSelectetTopicCell setExpansionStyle:UIExpansionStyleCollapsed animated:YES];
            self.currSelectionLevel = BMExpandbleSelectionCoutry;
            BMCountryTableViewCell *countryCell = (BMCountryTableViewCell*)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
            [countryCell select:YES];
       //}];
        [tableView beginUpdates];
        [tableView endUpdates];
        return;
    }
    BMCountryTableViewCell *countryCell = (BMCountryTableViewCell*)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
    [countryCell select:NO];
    if (self.lastSelectedTopicIndexPath) {
        BMTopicTableViewCell *prevSelectetTopicCell = (BMTopicTableViewCell*) [tableView cellForRowAtIndexPath:self.lastSelectedTopicIndexPath];
        [prevSelectetTopicCell collapseTopic];
        [prevSelectetTopicCell select:NO];
        [prevSelectetTopicCell setDescriptionHidden:YES];
        [prevSelectetTopicCell setExpansionStyle:UIExpansionStyleCollapsed animated:YES];
    }
    BMTopicTableViewCell *cell = (BMTopicTableViewCell*) [tableView cellForRowAtIndexPath:indexPath];
    [cell select:YES];
    self.lastSelectedTopicIndexPath = indexPath;
    NSUInteger subTopicsCount = [cell.topic.subtopics count];
    self.lastSelectedTopicExpandbleHeight = 48 + subTopicsCount*48 + 132;
    [tableView beginUpdates];
    if (self.currSelectionLevel != BMExpandbleSelectionTopic && self.currSelectionLevel != BMExpandbleSelectionCoutry) {
        [cell collapseTopic];
        [cell setExpansionStyle:UIExpansionStyleCollapsed animated:YES];
    }
    self.currSelectionLevel = BMExpandbleSelectionTopic;
    [cell setDescriptionHidden:NO];
    [cell setExpansionStyle:UIExpansionStyleExpanded animated:YES];
    [tableView endUpdates];
}

- (void)dataUpdated:(NSNotification*) notification{
    if ([self childViewControllers].count>0) {
        self.needsUpdateData = YES;
    } else {
        self.needsUpdateData = YES;
        [self updateDataIfNeeded];
    }
}

- (void) updateDataIfNeeded{
    if (self.needsUpdateData) {
        self.needsUpdateData = NO;
        JSSAlertViewResponder* responder = [[[JSSAlertView alloc] init] successOneButton:self.navigationController title:@"Success" text:@"Data updated!"];
        [responder addAction:^{
            NSManagedObjectContext *context = [RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"BMInitData"];
            NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
            fetchRequest.sortDescriptors = @[descriptor];
            NSError *error = nil;
            NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
            BMInitData *allData = [fetchedObjects firstObject];
            
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
            self.countries = [[allData.countries allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
            [self.tableView reloadData];
        }];
    }
}
#pragma mark - Private category implementation ()

@end