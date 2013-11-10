//
//  AllTouchesGestureRecognizer.h
//  FightClub
//
//  Created by Zhang, Qianze on 11/10/13.
//  Copyright (c) 2013 Zhang, Qianze. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllTouchesGestureRecognizer : UIGestureRecognizer

@property (nonatomic, assign) SEL target;
@property (nonatomic, assign) id object;

@end
