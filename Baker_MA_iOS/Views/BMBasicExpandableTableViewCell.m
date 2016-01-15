//
//  BMBasicExpandableTableViewCell.m
//  Baker_MA_iOS
//
//  Created by Evgeny Dedovets on 7/9/15.
//  Copyright (c) 2015 Panda Systems. All rights reserved.
//

#import "BMBasicExpandableTableViewCell.h"
#import <RestKit/CoreData.h>

@interface BMBasicExpandableTableViewCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint     *descriptionHeight;
@property (weak, nonatomic) IBOutlet UIButton               *liftBtn;
@property (assign, nonatomic) __block BOOL                  animationInProgress;

@end

@implementation BMBasicExpandableTableViewCell

- (void)awakeFromNib {
    self.descriptionBtnHidden = NO;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _descriptionHidden = YES;
    self.descriptionHeight.constant = 0;
    self.topLevelDescription.alpha = 0;
    self.bottomDescription.alpha = 0;
    self.liftBtn.alpha = 0;
    self.midDescription.alpha = 0;
    self.midBottomDescription.alpha = 0;
    self.animationInProgress = NO;
}

- (void)setExpansionStyle:(UIExpansionStyle)expansionStyle animated:(BOOL)animated {
    _expansionStyle = expansionStyle;
    if (_expansionStyle == UIExpansionStyleCollapsed) {
        if (![self.status isEqualToString:@"old"] && self.status) {
            self.statusMarkView.image = [UIImage imageNamed:@"yellowMark"];
        } else {
            self.statusMarkView.image = [UIImage imageNamed:@"redMark"];
        }
    } else {
        self.statusMarkView.image = [UIImage imageNamed:@"greenMark"];
        if (![self.status isEqualToString:@"old"]) {
            self.status = @"old";
            [self markAsSeen];
        }
    }
}

- (void)markAsSeen {
    NSError *error = nil;
    [self.context saveToPersistentStore:&error];
}


- (void)select:(BOOL)selected {
    if (selected) {
        self.titleView.backgroundColor = [UIColor expandableTableCellColorForSelectedState];
    } else {
        self.titleView.backgroundColor = [UIColor clearColor];
        
    }
}

- (void)setDescriptionHidden:(BOOL)descriptionHidden {
    if (descriptionHidden != _descriptionHidden) {
        _descriptionHidden = descriptionHidden;
        if (descriptionHidden) {
            self.descriptionHeight.constant = 0;
            if (self.animationInProgress) {
                self.topLevelDescription.hidden = YES;
                self.bottomDescription.hidden = YES;
                self.liftBtn.hidden = YES;
                self.midDescription.hidden = YES;
                self.midBottomDescription.hidden = YES;
            }
            
            [UIView animateWithDuration:0.3f animations:^{
                [self layoutIfNeeded];
                self.liftBtn.layer.opacity = 0;
                self.topLevelDescription.layer.opacity = 0;
                self.bottomDescription.layer.opacity = 0;
                self.midDescription.layer.opacity = 0;
                self.midBottomDescription.layer.opacity = 0;
            } completion:^(BOOL finished) {
                self.topLevelDescription.hidden = YES;
                self.bottomDescription.hidden = YES;
                self.liftBtn.hidden = YES;
                self.midDescription.hidden = YES;
                self.midBottomDescription.hidden = YES;
            }];
        } else {
            self.animationInProgress = YES;
            self.topLevelDescription.hidden = NO;
            self.midDescription.hidden = NO;
            self.bottomDescription.hidden = NO;
            self.descriptionHeight.constant = 132;
            if (!self.descriptionBtnHidden) {
                self.liftBtn.hidden = NO;
            }
            self.midBottomDescription.hidden = NO;
            [UIView animateWithDuration:0.3f animations:^{
                [self layoutIfNeeded];
                self.topLevelDescription.layer.opacity = 1;
                self.bottomDescription.layer.opacity = 1;
                if (!self.descriptionBtnHidden) {
                    self.liftBtn.layer.opacity = 1;
                }
                self.midDescription.layer.opacity = 1;
                self.midBottomDescription.layer.opacity = 1;
            } completion:^(BOOL finished) {
                self.animationInProgress = NO;
            }];
        }

    }
}


@end
