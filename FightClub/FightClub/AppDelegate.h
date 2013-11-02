//
//  AppDelegate.h
//  FightClub
//
//  Created by Zhang, Qianze on 10/24/13.
//  Copyright (c) 2013 Zhang, Qianze. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FightClubRootViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) UINavigationController* navigationController;
@property (nonatomic, retain) FightClubRootViewController* homeViewController;
@property (nonatomic, retain) UILabel* fcTitleLabelView;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
