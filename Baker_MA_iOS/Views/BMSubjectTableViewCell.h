//
//  BMSubjectTableViewCell.h
//  Baker_MA_iOS
//
//  Created by Evgeny Dedovets on 7/9/15.
//  Copyright (c) 2015 Panda Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMBasicExpandableTableViewCell.h"
#import "BMSubjectTableViewCellDelegate.h"

@class BMSubject;

@interface BMSubjectTableViewCell : BMBasicExpandableTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) id <BMSubjectTableViewCellDelegate> subjectTableViewCellDelegate;
@property (strong, nonatomic) BMSubject *subject;

@end
