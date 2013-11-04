//
//  Utils.h
//  FightClub
//
//  Created by Zhang, Qianze on 10/31/13.
//  Copyright (c) 2013 Zhang, Qianze. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AppDelegate;
@interface Utils : NSObject

+ (AppDelegate*)getFcAppDelegate;
+ (UIImage *)createImageByColor:(CGRect)frame color:(UIColor*)color cornerRadius:(CGFloat)corderRadius;
+ (NSArray*)sortTasks:(NSArray*)tasks;
@end
