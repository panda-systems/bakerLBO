//
//  BMInitData.h
//  Baker_MA_iOS
//
//  Created by Oleg Bolshakov on 7/22/15.
//  Copyright (c) 2015 Panda Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BMCountry, BMInfo;

@interface BMInitData : NSManagedObject

@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSNumber * timestamp;
@property (nonatomic, retain) NSSet *countries;
@property (nonatomic, retain) NSSet *info;
@property (nonatomic, retain) NSSet *settings;
@property (nonatomic, retain) NSNumber * databaseId;
@property (nonatomic, retain) NSString * dataChanged;
@property (nonatomic, retain) NSNumber * lastUpdate;
@end

@interface BMInitData (CoreDataGeneratedAccessors)

- (void)addCountriesObject:(BMCountry *)value;
- (void)removeCountriesObject:(BMCountry *)value;
- (void)addCountries:(NSSet *)values;
- (void)removeCountries:(NSSet *)values;

- (void)addInfoObject:(BMInfo *)value;
- (void)removeInfoObject:(BMInfo *)value;
- (void)addInfo:(NSSet *)values;
- (void)removeInfo:(NSSet *)values;

- (void)addSettingsObject:(NSManagedObject *)value;
- (void)removeSettingsObject:(NSManagedObject *)value;
- (void)addSettings:(NSSet *)values;
- (void)removeSettings:(NSSet *)values;

@end
