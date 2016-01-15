//
//  BMTopicTableViewCell.m
//  Baker_MA_iOS
//
//  Created by Evgeny Dedovets on 7/9/15.
//  Copyright (c) 2015 Panda Systems. All rights reserved.
//

#import "BMTopicTableViewCell.h"
#import "BMSubTopicTableViewCell.h"
#import "BMSubjectTableViewCell.h"
#import "BMSubject.h"
#import "BMSubTopic.h"
#import "BMTopic.h"

@interface BMTopicTableViewCell () <SLExpandableTableViewDatasource, SLExpandableTableViewDelegate, BMSubTopicTableViewDelegate>

@property (weak, nonatomic) IBOutlet SLExpandableTableView  *subTopicsTableView;
@property (nonatomic, assign) BMExpandableSelectionLevel    currSelectionLevel;

@end


@implementation BMTopicTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lastExpandedSection = -1;
    self.subTopicsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.subTopicsTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)collapseTopic {
    [self.subTopicsTableView collapseSection:(NSUInteger)self.lastExpandedSection animated:YES];
    BMSubTopicTableViewCell *subTopicCell = (BMSubTopicTableViewCell*)[self.subTopicsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:(NSUInteger)self.lastExpandedSection]];
    [subTopicCell setDescriptionHidden:YES];
    [subTopicCell select:NO];
}

- (void)setTopic:(BMTopic *)topic {
    _topic = topic;
    self.bottomDescription.text = topic.title;
    self.status = topic.status;
    if (topic.htmlData) {
        NSRange rangeOfElemStyle =[topic.htmlData rangeOfString:@"<head>"];
        if ((int)rangeOfElemStyle.length <= 0) {
            self.descriptionBtnHidden = YES;
        }
    }
    if (![self.status isEqualToString:@"old"] && self.status) {
        self.statusMarkView.image = [UIImage imageNamed:@"yellowMark"];
    }
    [self.subTopicsTableView reloadData];
}


- (void)markAsSeen{
    self.topic.status = @"old";
    [super markAsSeen];
}

- (IBAction)expandDescription:(id)sender {
    if ([self.topicTableViewCellDelegate respondsToSelector:@selector(shouldPerformSegue:withSender:description:andtitle:)]) {
        [self.topicTableViewCellDelegate shouldPerformSegue:CGPointMake([UIScreen mainScreen].bounds.size.width/2, self.frame.origin.y) withSender:self description:self.topic.htmlData andtitle:self.topic.title];
    }
}

#pragma mark - BMSubTopicTableViewDelegate

- (void)shouldProcessTapOnSection:(NSInteger)section withNewExpansionStyle:(UIExpansionStyle)style andSelectionLevel:(BMExpandableSelectionLevel)selectionLevel{
    if ([self.topicTableViewCellDelegate respondsToSelector:@selector(shouldUpdateSizeAtIndexPath:andChildUIExpansionStyle:andSelectionLevel:)]) {
        [self.topicTableViewCellDelegate shouldUpdateSizeAtIndexPath:[[NSIndexPath alloc] initWithIndex:section] andChildUIExpansionStyle:style andSelectionLevel:selectionLevel];
        
        self.currSelectionLevel = selectionLevel;
        if (self.currSelectionLevel == BMExpandbleSelectionSubTopic) {
           // BMSubTopicTableViewCell *subTopicCell = (BMSubTopicTableViewCell*)[self.subTopicsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:(NSUInteger)self.lastExpandedSection]];
             //   [subTopicCell setDescriptionHidden:NO];
        }
    }
}

- (void)shouldPerformSegue:(CGPoint)center withSender:(id)sender description:(NSString*)description andtitle:(NSString*)title{
    CGPoint newCenter = CGPointMake(center.x, center.y + self.frame.origin.y);
    if ([self.topicTableViewCellDelegate respondsToSelector:@selector(shouldPerformSegue:withSender:description:andtitle:)]) {
        [self.topicTableViewCellDelegate shouldPerformSegue:newCenter withSender:self description:description andtitle:title];
    }
}

#pragma mark - SLExpandableTableViewDatasource

- (BOOL)tableView:(SLExpandableTableView *)tableView needsToDownloadDataForExpandableSection:(NSInteger)section {
    return NO;
}

- (BOOL)tableView:(SLExpandableTableView *)tableView canExpandSection:(NSInteger)section {
    return YES;
}


- (UITableViewCell<UIExpandingTableViewCell> *)tableView:(SLExpandableTableView *)tableView expandingCellForSection:(NSInteger)section {
    static NSString *CellIdentifier = @"subTopicTableViewCell";
    BMSubTopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = (BMSubTopicTableViewCell*)[[[NSBundle mainBundle] loadNibNamed:@"BMSubTopicTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.subTopicTableViewDelegate = self;
    cell.section = section;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    BMSubTopic *subtopic = (BMSubTopic*)[[[self.topic.subtopics allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]] objectAtIndex:section];
    cell.subTopic = subtopic;
    cell.subTopicTitle.text = cell.subTopic.title;
    cell.topLevelDescription.text = self.topLevelDescription.text;
    cell.midDescription.text = self.topic.title;
    cell.bottomDescription.text = cell.subTopic.title;
    cell.context = self.context;
    return cell;
}


#pragma mark - SLExpandableTableViewDelegate

- (void)tableView:(SLExpandableTableView *)tableView downloadDataForExpandableSection:(NSInteger)section {
    [tableView expandSection:section animated:YES];
}

- (void)tableView:(SLExpandableTableView *)tableView willCollapseSection:(NSUInteger)section animated:(BOOL)animated {
    BMSubTopicTableViewCell *subTopicCell = (BMSubTopicTableViewCell*)[self.subTopicsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    [subTopicCell setDescriptionHidden:YES];
}

- (void)tableView:(SLExpandableTableView *)tableView didCollapseSection:(NSUInteger)section animated:(BOOL)animated {
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currSelectionLevel == BMExpandbleSelectionSubTopic && indexPath.row == 0 && indexPath.section == (NSUInteger)self.lastExpandedSection) {
        return 180;
    }

    if (self.currSelectionLevel == BMExpandbleSelectionSubject && [indexPath isEqual:self.lastSelectedSubjectIndexPath] ) {
        return 180;
    }
    return 48;
}

- (void)tableView:(SLExpandableTableView *)tableView willExpandSection:(NSUInteger)section animated:(BOOL)animated {
    if (self.lastExpandedSection != -1 && self.lastExpandedSection != section) {
        [self.subTopicsTableView collapseSection:(NSUInteger)self.lastExpandedSection animated:YES];
        BMSubTopicTableViewCell *subTopicCell = (BMSubTopicTableViewCell*)[self.subTopicsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:(NSUInteger)self.lastExpandedSection]];
        [subTopicCell setDescriptionHidden:YES];
    }
    self.lastExpandedSection = (int)section;
    BMSubTopicTableViewCell *newSubTopicCell = (BMSubTopicTableViewCell*)[self.subTopicsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:(NSUInteger)self.lastExpandedSection]];
    [newSubTopicCell setDescriptionHidden:NO];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.topic.subtopics count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    BMSubTopic *subtopic = (BMSubTopic*)[[[self.topic.subtopics allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]] objectAtIndex:section];
    return [[[subtopic.subjects allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]] count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"subjectTableViewCell";
    BMSubjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = (BMSubjectTableViewCell*)[[[NSBundle mainBundle] loadNibNamed:@"BMSubjectTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    BMSubTopic *subtopic = (BMSubTopic*)[[[self.topic.subtopics allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]] objectAtIndex:indexPath.section];

    BMSubject *subject = (BMSubject*)[[[subtopic.subjects allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]] objectAtIndex:indexPath.row - 1];
    BMSubTopicTableViewCell *subTopicCell = (BMSubTopicTableViewCell*)[self.subTopicsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
    cell.subjectTableViewCellDelegate = (id)subTopicCell;
    cell.subject = subject;
    cell.topLevelDescription.text = self.topLevelDescription.text;
    cell.midDescription.text = self.topicTitle.text;
    cell.bottomDescription.text = cell.subject.title;
    cell.subjectLabel.text = cell.subject.title;
    cell.context = self.context;
    cell.midBottomDescription.text = ((BMSubTopic*)[[self.topic.subtopics  allObjects] objectAtIndex:indexPath.section]).title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.lastSelectedSubjectIndexPath isEqual:indexPath]) {
        BMSubjectTableViewCell *prevSelectedSubjCell = (BMSubjectTableViewCell*) [tableView cellForRowAtIndexPath:self.lastSelectedSubjectIndexPath];
        if (prevSelectedSubjCell.expansionStyle == UIExpansionStyleCollapsed) {
            [prevSelectedSubjCell select:YES];
            [prevSelectedSubjCell setDescriptionHidden:NO];
            [prevSelectedSubjCell setExpansionStyle:UIExpansionStyleExpanded animated:YES];
            self.currSelectionLevel = BMExpandbleSelectionSubject;
            
            BMSubTopicTableViewCell *subTopicCell = (BMSubTopicTableViewCell*)[self.subTopicsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:(NSUInteger)self.lastExpandedSection]];
            [subTopicCell setDescriptionHidden:YES];
            [subTopicCell select:NO];
            [tableView beginUpdates];
            
            [tableView endUpdates];
        }
        
        return;
    }
    
    if (self.lastSelectedSubjectIndexPath) {
        BMSubjectTableViewCell *prevSelectedSubjCell = (BMSubjectTableViewCell*) [tableView cellForRowAtIndexPath:self.lastSelectedSubjectIndexPath];
        [prevSelectedSubjCell select:NO];
        [prevSelectedSubjCell setDescriptionHidden:YES];
        [prevSelectedSubjCell setExpansionStyle:UIExpansionStyleCollapsed animated:YES];
    }
    self.lastSelectedSubjectIndexPath = indexPath;
    BMSubjectTableViewCell *selectedSubjCell = (BMSubjectTableViewCell*) [tableView cellForRowAtIndexPath:indexPath];
    [selectedSubjCell select:YES];
    [selectedSubjCell setDescriptionHidden:NO];
    BMSubTopicTableViewCell *subTopicCell = (BMSubTopicTableViewCell*)[self.subTopicsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:(NSUInteger)self.lastExpandedSection]];
    [subTopicCell setDescriptionHidden:YES];
    [selectedSubjCell setExpansionStyle:UIExpansionStyleExpanded animated:YES];
    [subTopicCell select:NO];
    self.currSelectionLevel = BMExpandbleSelectionSubject;
    [tableView beginUpdates];
    
    [tableView endUpdates];
}

@end
