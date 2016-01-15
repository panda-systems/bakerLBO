//
//  BMTopicTableViewCell.h
//  Baker_MA_iOS
//
//  Created by Evgeny Dedovets on 7/9/15.
//  Copyright (c) 2015 Panda Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMBasicExpandableTableViewCell.h"
#import "BMTopicTableViewCellDelegate.h"

@class BMTopic;

@interface BMTopicTableViewCell : BMBasicExpandableTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *topicTitle;
@property (weak, nonatomic) id <BMTopicTableViewCellDelegate> topicTableViewCellDelegate;
@property (strong, nonatomic) BMTopic *topic;
@property (nonatomic, strong) NSIndexPath                   *lastSelectedSubjectIndexPath;
@property (nonatomic, assign) int                           lastExpandedSection;

- (void)collapseTopic;

@end
