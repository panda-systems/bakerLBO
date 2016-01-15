//
//  BMSubTopicTableViewDelegate.h
//  Baker_MA_iOS
//
//  Created by Evgeny Dedovets on 7/9/15.
//  Copyright (c) 2015 Panda Systems. All rights reserved.
//

@protocol BMSubTopicTableViewDelegate <NSObject>

- (void)shouldProcessTapOnSection:(NSInteger)section withNewExpansionStyle:(UIExpansionStyle)style andSelectionLevel:(BMExpandableSelectionLevel)selectionLevel;
- (void)shouldPerformSegue:(CGPoint)center withSender:(id)sender description:(NSString*)description andtitle:(NSString*)title;
@end
