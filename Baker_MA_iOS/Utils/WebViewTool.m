//
//  WebViewCssRule.m
//  Baker_MA_iOS
//
//  Created by Panda Systems on 7/21/15.
//  Copyright (c) 2015 Panda Systems. All rights reserved.
//

#import "WebViewTool.h"
#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>
#import "BMSettings.h"
#import "BMInitData.h"

@implementation WebViewTool

+ (instancetype)sharedWebViewTool {
    static WebViewTool *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (instancetype) init {
    self = [super init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataUpdated:) name:@"BMDataUpdated" object:nil];
    return self;
}

-(void) dataUpdated:(NSNotification*)notification{
    NSManagedObjectContext *context = [RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"BMInitData"];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"databaseId" ascending:YES];
    fetchRequest.sortDescriptors = @[descriptor];
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    BMSettings* settings = [((BMInitData*)[fetchedObjects firstObject]).settings.allObjects firstObject];
    //NSString *timeStamp = ((BMInitData*)[fetchedObjects firstObject]).timestamp;
    
    self.cssStyle = settings.css;
}

-(NSMutableString*)insertCssRuleString:(NSString*)insertIntoString{
    NSMutableString *mutableHtmlString = [insertIntoString mutableCopy];
    NSRange rangeOfElemStyle = [insertIntoString rangeOfString:@"<head>"];
    if ((int)rangeOfElemStyle.length > 0) {
        NSString* cssStyle = CSS_STYLE;
        if (self.cssStyle) {
            cssStyle = self.cssStyle;
        }
        [mutableHtmlString insertString:cssStyle atIndex:rangeOfElemStyle.location+ rangeOfElemStyle.length];
    }
    return mutableHtmlString;
}

-(void) updateCSSString{
    [self dataUpdated:nil];
}
@end
