//
//  BMContactInfo.h
//  Baker_MA_iOS
//
//  Created by Evgeny Dedovets on 7/20/15.
//  Copyright (c) 2015 Panda Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMContact.h"

@interface BMContactInfo : NSObject

@property (nonatomic, strong) BMContact * contact;
@property (nonatomic, strong) NSString *country;

@end
