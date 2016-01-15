//
//  BMSubTopicTableViewCell.h
//  Baker_MA_iOS
//
//  Created by Evgeny Dedovets on 7/9/15.
//  Copyright (c) 2015 Panda Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMBasicExpandableTableViewCell.h"
#import "BMSubTopicTableViewDelegate.h"

@class BMSubTopic;

@interface BMSubTopicTableViewCell : BMBasicExpandableTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *subTopicTitle;
@property (weak, nonatomic) id <BMSubTopicTableViewDelegate> subTopicTableViewDelegate;
@property (assign, nonatomic) NSInteger section;
@property (strong, nonatomic) BMSubTopic *subTopic;

@end
