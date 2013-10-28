//
//  ServicesManager.h
//  FightClub
//
//  Created by Zhang, Qianze on 10/27/13.
//  Copyright (c) 2013 Zhang, Qianze. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum FcServiceType {
    FC_SERVICE_TYPE_LOGIN = 0,
    FC_SERVICE_TYPE_GET_USER_TASK = 1
} FcServiceType;

@interface ServicesManager : NSObject

+ (ServicesManager*) getInstance;
+ (NSString*) getServiceURLById:(FcServiceType)type;

@property (nonatomic, retain) NSMutableDictionary* services;

@end
