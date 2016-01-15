//
//  BMContactsTableViewCell.h
//  Baker_MA_iOS
//
//  Created by Evgeny Dedovets on 7/20/15.
//  Copyright (c) 2015 Panda Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"
#import "MGSwipeButton.h"

@class BMContactInfo;

@protocol BMContactsTableViewCellDelegate <NSObject>

-(void) call:(BMContactInfo*)contactInfo;
-(void) sendMail:(BMContactInfo*)contactInfo;
-(void) addToContacts:(BMContactInfo*)contactInfo;


@end

@interface BMContactsTableViewCell : MGSwipeTableCell

@property (nonatomic, strong) BMContactInfo *contactInfo;
@property id<BMContactsTableViewCellDelegate> actionDelegate;

@end
