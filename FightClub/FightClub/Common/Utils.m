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
    NSMutableDictionary* sortedTasks = [[NSMutableDictionary alloc] init];
    for (NSDictionary* task in tasks) {
        NSString* tgid = [NSString stringWithFormat:@"%@", [task valueForKey:TASK_ATTR_TGID]];
        
        NSMutableArray* itemsForCurTgid = [sortedTasks valueForKey:tgid];
        
        if (itemsForCurTgid == nil) {
            itemsForCurTgid = [[NSMutableArray alloc] init];
            [sortedTasks setValue:itemsForCurTgid forKey:tgid];
        }
        
        [itemsForCurTgid addObject:task];
        
    }
    
    
    NSMutableArray* result = [[NSMutableArray alloc] init];
    
    for (NSString* key in [sortedTasks allKeys]) {
        NSDictionary* items = [sortedTasks valueForKey:key];
        [result addObject:items];
    }
    
    return result;
}

@end
