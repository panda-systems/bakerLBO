//
//  BMCountry.h
//  Baker_MA_iOS
//
//  Created by Oleg Bolshakov on 7/22/15.
//  Copyright (c) 2015 Panda Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BMContact, BMTopic;

@interface BMCountry : NSManagedObject

@property (nonatomic, retain) NSNumber * countryId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSSet *contacts;
@property (nonatomic, retain) NSSet *topics;
@end

@interface BMCountry (CoreDataGeneratedAccessors)

- (void)addContactsObject:(BMContact *)value;
- (void)removeContactsObject:(BMContact *)value;
- (void)addContacts:(NSSet *)values;
- (void)removeContacts:(NSSet *)values;

- (void)addTopicsObject:(BMTopic *)value;
- (void)removeTopicsObject:(BMTopic *)value;
- (void)addTopics:(NSSet *)values;
- (void)removeTopics:(NSSet *)values;

@end
