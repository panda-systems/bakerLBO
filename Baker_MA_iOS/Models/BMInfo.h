//
//  BMInfo.h
//  Baker_MA_iOS
//
//  Created by Oleg Bolshakov on 7/22/15.
//  Copyright (c) 2015 Panda Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BMInfo : NSManagedObject

@property (nonatomic, retain) NSString * versionNumber;
@property (nonatomic, retain) NSString * textData;

@end
