//
//  BMSubTopicTableViewCell.m
//  Baker_MA_iOS
//
//  Created by Evgeny Dedovets on 7/9/15.
//  Copyright (c) 2015 Panda Systems. All rights reserved.
//

#import "BMSubTopicTableViewCell.h"
#import "BMSubtopic.h"
#import "BMSubjectTableViewCellDelegate.h"

@interface BMSubTopicTableViewCell () <BMSubjectTableViewCellDelegate>


@end

@implementation BMSubTopicTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSubTopic:(BMSubTopic *)subTopic {
    _subTopic = subTopic;
    self.status = subTopic.status;
    if (subTopic.htmlData) {
        NSRange rangeOfElemStyle =[subTopic.htmlData rangeOfString:@"<head>"];
        if ((int)rangeOfElemStyle.length <= 0) {
            self.descriptionBtnHidden = YES;
        }
    }
    if (![self.status isEqualToString:@"old"] && self.status) {
        self.statusMarkView.image = [UIImage imageNamed:@"yellowMark"];
    }
}

- (void)setExpansionStyle:(UIExpansionStyle)expansionStyle animated:(BOOL)animated
{
    BMExpandableSelectionLevel level;
    [super setExpansionStyle:expansionStyle animated:animated];
    if (expansionStyle == UIExpansionStyleExpanded) {
        level = BMExpandbleSelectionSubTopic;
        [self select:YES];
    } else {
        level = BMExpandbleSelectionTopic;
        [self select:NO];
    }
    if ([self.subTopicTableViewDelegate respondsToSelector:@selector(shouldProcessTapOnSection:withNewExpansionStyle:andSelectionLevel:)]) {
        [self.subTopicTableViewDelegate shouldProcessTapOnSection:self.section withNewExpansionStyle:expansionStyle andSelectionLevel:level];
    }
}

- (void)markAsSeen{
    self.subTopic.status = @"old";
    [super markAsSeen];
}

- (IBAction)expandDescription:(id)sender {
    CGPoint center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, self.frame.origin.y + 48);
    if ([self.subTopicTableViewDelegate respondsToSelector:@selector(shouldPerformSegue:withSender:description:andtitle:)]) {
        [self.subTopicTableViewDelegate shouldPerformSegue: center withSender:self description:self.subTopic.htmlData andtitle:self.subTopic.title];
    }
}

- (void)shouldPerformSegue:(CGPoint)center withSender:(id)sender description:(NSString*)description andtitle:(NSString*)title {
    
    if ([self.subTopicTableViewDelegate respondsToSelector:@selector(shouldPerformSegue:withSender:description:andtitle:)]) {
        [self.subTopicTableViewDelegate shouldPerformSegue: center withSender:sender description:description andtitle:title];
    }
}


@end
