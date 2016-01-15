//
//  UIWebView+BMHighlightSearchResults.h
//  Baker_MA_iOS
//
//  Created by Panda Systems on 7/21/15.
//  Copyright (c) 2015 Panda Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (BMHighlightSearchResults)

- (NSInteger)highlightAllOccurencesOfString:(NSString*)str;
- (void)removeAllHighlights;

@end
