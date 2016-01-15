//
//  BMSubjectTableViewCellDelegate.h
//  Baker_MA_iOS
//
//  Created by Evgeny Dedovets on 7/16/15.
//  Copyright (c) 2015 Panda Systems. All rights reserved.
//


@protocol BMSubjectTableViewCellDelegate <NSObject>

- (void)shouldPerformSegue:(CGPoint)center withSender:(id)sender description:(NSString*)description andtitle:(NSString*)title;

@end