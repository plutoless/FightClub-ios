//
//  AllTouchesGestureRecognizer.m
//  FightClub
//
//  Created by Zhang, Qianze on 11/10/13.
//  Copyright (c) 2013 Zhang, Qianze. All rights reserved.
//

#import "AllTouchesGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>


@implementation AllTouchesGestureRecognizer

- (id) initWithTarget:(id)target action:(SEL)action
{
    self = [super initWithTarget:target action:action];
    if (self != nil) {
        self.object = target;
        self.target = action;
    }
    
    return self;
}

#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.object performSelector:self.target withObject:self.object];
}

@end
