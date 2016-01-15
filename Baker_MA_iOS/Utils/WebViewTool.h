//
//  WebViewCssRule.h
//  Baker_MA_iOS
//
//  Created by Panda Systems on 7/21/15.
//  Copyright (c) 2015 Panda Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#define CSS_STYLE @"<style> body{ color: white; background-color: #909090; font-family:'Roboto-Light' !important; font-size: 12pt !important; margin-left: 16pt; margin-right: 16pt;} span{ color: inherit!important; font-size: 12pt !important; margin-top: 0px; margin-bottom: 0px; } table, th, td { border: 2px solid inherit!important; background-color: white!important ;font-size: 10pt !important;} td[valign]{border: 2px solid white!important} tr td{ background-color: #909090!important; padding:5pt;} a{ color:#c3122e; display: block; text-overflow: ellipsis; overflow: hidden; white-space: nowrap;} h2 a{ color: inherit; } a span{ color: inherit!important; } p {font-family: 'Roboto-Light'!important; }</style><meta name=\"viewport\" content=\"width=320\"/>"

@interface WebViewTool : NSObject

@property(nonatomic, copy) NSString* cssStyle;

+ (instancetype)sharedWebViewTool;
- (NSMutableString*)insertCssRuleString:(NSString*)insertIntoString;
- (void) updateCSSString;

@end
