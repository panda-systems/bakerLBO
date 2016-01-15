//
//  BMSubTopic.h
//  Baker_MA_iOS
//
//  Created by Oleg Bolshakov on 7/22/15.
//  Copyright (c) 2015 Panda Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BMSubject;

@interface BMSubTopic : NSManagedObject

@property (nonatomic, retain) NSString * htmlData;
@property (nonatomic, retain) NSNumber * subTopicId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSSet *subjects;
@end

@interface BMSubTopic (CoreDataGeneratedAccessors)

- (void)addSubjectsObject:(BMSubject *)value;
- (void)removeSubjectsObject:(BMSubject *)value;
- (void)addSubjects:(NSSet *)values;
- (void)removeSubjects:(NSSet *)values;

@end
