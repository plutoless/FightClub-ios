//
//  ServicesManager.h
//  FightClub
//
//  Created by Zhang, Qianze on 10/27/13.
//  Copyright (c) 2013 Zhang, Qianze. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServicesManager : NSObject

+ (ServicesManager*) getInstance;

@property (nonatomic, retain) NSMutableDictionary* services;

@end
