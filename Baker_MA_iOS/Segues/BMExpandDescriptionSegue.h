//
//  CPHHelpCustomSegue.h
//  Watcher
//
//  Created by Oleg Bolshakov on 4/2/15.
//  Copyright (c) 2015 CPHCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMExpandDescriptionSegue : UIStoryboardSegue

@property (nonatomic, assign) NSString                      *selectedDescription;
@property (nonatomic, assign) NSString                      *selectedTitle;
@property (nonatomic, assign) CGPoint                       destinationCenter;

@end
