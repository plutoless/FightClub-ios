//
//  Utils.m
//  FightClub
//
//  Created by Zhang, Qianze on 10/31/13.
//  Copyright (c) 2013 Zhang, Qianze. All rights reserved.
//

#import "Utils.h"
#import "FcConstant.h"
#import "AppDelegate.h"

@implementation Utils

+ (AppDelegate*)getFcAppDelegate
{
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]);
}

+ (UIImage *)createImageByColor:(CGRect)frame color:(UIColor*)color cornerRadius:(CGFloat)corderRadius
{
    UIView* colorView = [[UIView alloc] initWithFrame:frame];
    colorView.backgroundColor = color;
    
    UIGraphicsBeginImageContext(colorView.bounds.size);
    [colorView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    if (corderRadius != 0.0f) {
        colorView.layer.cornerRadius = corderRadius;
    }
    
    UIImage* colorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    colorView = nil;
    
    return colorImage;
}

+ (NSArray*) sortTasks:(NSArray *)tasks
{
    NSMutableDictionary* categoryMapping = [[NSMutableDictionary alloc] init];
    for (NSMutableDictionary* task in tasks) {
        NSString* tgid = [NSString stringWithFormat:@"%@", [task valueForKey:TASK_ATTR_TGID]];
        
        NSMutableArray* itemsForCurTgid = [[categoryMapping valueForKey:tgid] valueForKey:CAT_ATTR_ITEMS];
        
        if (itemsForCurTgid == nil) {
            NSMutableDictionary* category = [Utils createCatWithTemplateTask:task];
            [categoryMapping setValue:category forKey:tgid];
            itemsForCurTgid = [category valueForKey:CAT_ATTR_ITEMS];
        }
        
        [itemsForCurTgid addObject:task];
        
    }
    
    
    NSMutableArray* result = [[NSMutableArray alloc] init];
    
    
    for (NSString* key in [categoryMapping allKeys]) {
        NSMutableDictionary* category = [categoryMapping valueForKey:key];
        NSMutableArray* items = [category valueForKey:CAT_ATTR_ITEMS];
        NSArray* sortedItems = [items sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSDictionary* itemA = (NSDictionary*)obj1;
            NSDictionary* itemB = (NSDictionary*)obj2;
            int isdoneA = [[itemA valueForKey:TASK_ATTR_ISDONE] intValue];
            int isdoneB = [[itemB valueForKey:TASK_ATTR_ISDONE] intValue];
            
            if (isdoneA > isdoneB) {
                return NSOrderedDescending;
            } else if(isdoneA < isdoneB){
                return NSOrderedAscending;
            }
            
            return NSOrderedSame;
        }];
        NSMutableArray* mutableSortedItems = [[NSMutableArray alloc] initWithArray:sortedItems];
        [category setObject:mutableSortedItems forKey:CAT_ATTR_ITEMS];
        [result addObject:category];
    }
    
    NSArray* sortedResult = [result sortedArrayUsingComparator:^NSComparisonResult(id a, id b){
        int priorityA = [[((NSArray*)a) valueForKey:CAT_ATTR_PRIORITY] intValue];
        int priorityB = [[((NSArray*)b) valueForKey:CAT_ATTR_PRIORITY] intValue];
        if (priorityA > priorityB) {
            return NSOrderedAscending;
        } else if(priorityB >priorityA){
            return NSOrderedDescending;
        }
        
        return NSOrderedSame;
    }];
    
    NSMutableArray* mutableSortedResult = [[NSMutableArray alloc] initWithArray:sortedResult];
    
    return mutableSortedResult;
}

+ (NSString*)getCurrentTimeStamp
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:MM:SS"];
    NSDate* date = [NSDate date];
    NSString* dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+ (NSMutableDictionary*)createCatWithTemplateTask:(NSMutableDictionary *)templateTask
{
    NSMutableDictionary* category = [[NSMutableDictionary alloc] init];
    NSMutableArray* itemsForCurTgid = [[NSMutableArray alloc] init];
    
    [category setValue:itemsForCurTgid forKey:CAT_ATTR_ITEMS];
    [category setValue:[templateTask valueForKey:TASK_ATTR_TGID] forKey:CAT_ATTR_TGID];
    [category setValue:[templateTask valueForKey:TASK_ATTR_CATEGORY] forKey:CAT_ATTR_TITLE];
    [category setValue:[templateTask valueForKey:TASK_ATTR_PRIORITY] forKey:CAT_ATTR_PRIORITY];
    
    return category;
}

@end
