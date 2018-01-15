//
//  AppDelegate.h
//  ChatBaseSDK
//
//  Created by Diego Jimenez Martinez on 15/1/18.
//  Copyright © 2018 PGDMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

