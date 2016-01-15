//
//  BMTopicTableViewCellProtocol.h
//  Baker_MA_iOS
//
//  Created by Evgeny Dedovets on 7/9/15.
//  Copyright (c) 2015 Panda Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BMTopicTableViewCellDelegate <NSObject>

- (void)shouldUpdateSizeAtIndexPath:(NSIndexPath*)indexPath andChildUIExpansionStyle:(UIExpansionStyle)style andSelectionLevel:(BMExpandableSelectionLevel)selectionLevel;
- (void)shouldPerformSegue:(CGPoint)center withSender:(id)sender description:(NSString*)description andtitle:(NSString*)title;

@end
