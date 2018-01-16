//
//  ViewController.m
//  ChatBaseSDK
//
//  Created by Diego Jimenez Martinez on 15/1/18.
//  Copyright © 2018 PGDMobile. All rights reserved.
//

#import "ViewController.h"

#import "CBHomeViewController.h"
#import "cbsdk_login.h"

@interface ViewController ()
{
    CBHomeViewController *homeScreen;
    CBWelcomeViewController *welcomeScreen;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //
    // Add Observers for ViewControllers Notifications
    //
    // Load homeViewController for normal initialization
    // 1.- Observer for main user credentials.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(CBWelcomeViewControllerNotification:)
                                                 name:@"CBWelcomeViewControllerNotification"
                                               object:nil];
    
    // 2.- Load welcomeViewController for user credentials
    NSString *frameworkBundleID = @"com.iwazowski.ChatBaseSDK";
    NSBundle *frameworkBundle = [NSBundle bundleWithIdentifier:frameworkBundleID];
    welcomeScreen = [[CBWelcomeViewController alloc] initWithNibName:@"CBWelcomeViewController" bundle:frameworkBundle];
    [welcomeScreen CBWelcomeViewControllerInitialization:1];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NSNotificationCenter selectors

- (void)CBWelcomeViewControllerNotification:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSString *res = [userInfo objectForKey:@"response"];
    //NSLog(@"%@", userInfo);
    
    if ([res isEqualToString:@"autologin"]) {
        NSLog(@"CBWelcomeViewControllerNotification:autologin");
        // Show CBHomeViewController
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *frameworkBundleID = @"com.iwazowski.ChatBaseSDK";
            NSBundle *frameworkBundle = [NSBundle bundleWithIdentifier:frameworkBundleID];
            homeScreen = [[CBHomeViewController alloc] initWithNibName:@"CBHomeViewController" bundle:frameworkBundle];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController pushViewController:homeScreen animated:NO];
            });
        });
        
    }else if ([res isEqualToString:@"nouserfound"]) {
        NSLog(@"CBWelcomeViewControllerNotification:nouserfound");
        // Show CBWelcomeViewController
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:welcomeScreen animated:NO];
        });
        
    }else if ([res isEqualToString:@"Successfull"]) {
        NSLog(@"CBWelcomeViewControllerNotification:Successfull");
        // Show CBWelcomeViewController
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *frameworkBundleID = @"com.iwazowski.ChatBaseSDK";
            NSBundle *frameworkBundle = [NSBundle bundleWithIdentifier:frameworkBundleID];
            homeScreen = [[CBHomeViewController alloc] initWithNibName:@"CBHomeViewController" bundle:frameworkBundle];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController pushViewController:homeScreen animated:NO];
            });
        });
        
    }else if ([res isEqualToString:@"logout"]) {
        NSLog(@"CBWelcomeViewControllerNotification:logout");
        // Show CBWelcomeViewController
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:welcomeScreen animated:NO];
        });
        
    }
}

@end
