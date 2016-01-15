//
//  BMDescriptionViewController.h
//  Baker_MA_iOS
//
//  Created by Evgeny Dedovets on 7/17/15.
//  Copyright (c) 2015 Panda Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMDescriptionViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *liftBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLiftSpace;
@property (assign, nonatomic) CGPoint dismissDestinationCenter;
@property (strong, nonatomic) NSString *descriptionTitle;
@property (nonatomic, retain) NSString *htmlData;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *titleContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleContainerHeight;

@end
