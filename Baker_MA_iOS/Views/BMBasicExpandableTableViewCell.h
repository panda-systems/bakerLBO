//
//  BMBasicExpandableTableViewCell.h
//  Baker_MA_iOS
//
//  Created by Evgeny Dedovets on 7/9/15.
//  Copyright (c) 2015 Panda Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLExpandableTableView.h"
#import "UIColor+BM.h"

typedef enum {
    BMExpandbleSelectionCoutry = 0,
    BMExpandbleSelectionTopic = 1,
    BMExpandbleSelectionSubTopic = 2,
    BMExpandbleSelectionSubject
} BMExpandableSelectionLevel;


@interface BMBasicExpandableTableViewCell : UITableViewCell<UIExpandingTableViewCell>

@property (nonatomic, readonly) UIExpansionStyle expansionStyle;
@property (nonatomic, assign, getter = isLoading) BOOL loading;
@property (nonatomic, assign)   BOOL descriptionHidden;
@property (weak, nonatomic) IBOutlet UIView                 *titleView;
@property (weak, nonatomic) IBOutlet UIImageView            *statusMarkView;
@property (weak, nonatomic) IBOutlet UILabel                *topLevelDescription;
@property (weak, nonatomic) IBOutlet UILabel                *midDescription;
@property (weak, nonatomic) IBOutlet UILabel                *bottomDescription;
@property (weak, nonatomic) IBOutlet UILabel                *midBottomDescription;
@property (assign, nonatomic) BOOL                          descriptionBtnHidden;
@property (strong, nonatomic) NSString                      *status;
@property (nonatomic, strong) NSManagedObjectContext        *context;

- (void)setExpansionStyle:(UIExpansionStyle)expansionStyle animated:(BOOL)animated;
- (void)select:(BOOL)selected;
- (void)markAsSeen;

@end
