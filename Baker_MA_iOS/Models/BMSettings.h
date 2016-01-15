//
//  BMSettings.h
//  Baker_MA_iOS
//
//  Created by Oleg Bolshakov on 7/24/15.
//  Copyright (c) 2015 Panda Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BMSettings : NSManagedObject

@property (nonatomic, retain) NSString * introduction;
@property (nonatomic, retain) NSString * databaseName;
@property (nonatomic, retain) NSNumber * settingsId;
@property (nonatomic, retain) NSString * css;
@property (nonatomic, retain) NSString * info;
@property (nonatomic, retain) NSString * status;

@end
