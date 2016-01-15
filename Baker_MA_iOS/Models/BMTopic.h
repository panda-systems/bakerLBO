//
//  BMTopic.h
//  Baker_MA_iOS
//
//  Created by Oleg Bolshakov on 7/22/15.
//  Copyright (c) 2015 Panda Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BMSubTopic;

@interface BMTopic : NSManagedObject

@property (nonatomic, retain) NSString * htmlData;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * topicId;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSSet *subtopics;
@end

@interface BMTopic (CoreDataGeneratedAccessors)

- (void)addSubtopicsObject:(BMSubTopic *)value;
- (void)removeSubtopicsObject:(BMSubTopic *)value;
- (void)addSubtopics:(NSSet *)values;
- (void)removeSubtopics:(NSSet *)values;

@end
