//
//  BMSubjectTableViewCell.m
//  Baker_MA_iOS
//
//  Created by Evgeny Dedovets on 7/9/15.
//  Copyright (c) 2015 Panda Systems. All rights reserved.
//

#import "BMSubjectTableViewCell.h"
#import "BMSubject.h"

@implementation BMSubjectTableViewCell

- (void)awakeFromNib {
   [super awakeFromNib];
}

- (IBAction)expandDescription:(id)sender {
    if ([self.subjectTableViewCellDelegate respondsToSelector:@selector(shouldPerformSegue:withSender:description:andtitle:)]) {
        [self.subjectTableViewCellDelegate shouldPerformSegue: CGPointMake([UIScreen mainScreen].bounds.size.width/2, self.frame.origin.y + 48) withSender:self description:self.subject.htmlData andtitle:self.subject.title];
    }
}

- (void)setSubject:(BMSubject *)subject {
    _subject = subject;
    self.status = subject.status;
    if (![self.status isEqualToString:@"old"] && self.status) {
        self.statusMarkView.image = [UIImage imageNamed:@"yellowMark"];
    }
}

- (void)markAsSeen{
    self.subject.status = @"old";
    [super markAsSeen];
}

@end
