//
//  SecManager.h
//  FightClub
//
//  Created by Zhang, Qianze on 10/26/13.
//  Copyright (c) 2013 Zhang, Qianze. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SecManager : NSObject

+ (SecManager*) getInstance;

@property (nonatomic, retain) NSMutableDictionary* secAttributes;

@end
