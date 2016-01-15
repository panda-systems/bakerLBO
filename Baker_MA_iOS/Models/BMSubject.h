//
//  BMSubject.h
//  Baker_MA_iOS
//
//  Created by Oleg Bolshakov on 7/22/15.
//  Copyright (c) 2015 Panda Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BMSubject : NSManagedObject

@property (nonatomic, retain) NSString * htmlData;
@property (nonatomic, retain) NSNumber * subjectId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * status;

@end
