//
//  CBLoginViewController.m
//  chatbase.sdk.ios
//
//  Created by Diego Jimenez Martinez on 23/9/17.
//  Copyright © 2017 chatbase.co. All rights reserved.
//

#import "CBLoginViewController.h"
#import "CBSignupViewController.h"
#import "CBForgotPsswrdViewController.h"

#import "cbsdk_login.h"

#import "CBloginclass.h"

@interface CBLoginViewController ()<UIGestureRecognizerDelegate>

@property(nonatomic, retain) IBOutlet UITextField *username;
@property(nonatomic, retain) IBOutlet UITextField *password;
@property(nonatomic, retain) IBOutlet UIButton *loginButton;
@property(nonatomic, retain) IBOutlet UIButton *gotosignupButton;
@property(nonatomic, retain) IBOutlet UIButton *forgotpsswrdButton;

@property(nonatomic, retain) IBOutlet UIButton *cancelButton;

@property (nonatomic, retain) IBOutlet UIImageView *logoImageWVC;
@property (nonatomic, retain) IBOutlet UILabel *appTitleWVC;

- (IBAction)signupButtonPressed:(id)sender;
- (IBAction)forgotpsswrdViewController:(id)sender;
- (IBAction)cancelLoginViewController:(id)sender;

- (IBAction)loginButtonPressed:(id)sender;

@end

@implementation CBLoginViewController

#pragma mark -
#pragma mark IBActions

- (IBAction)signupButtonPressed:(id)sender
{
    NSString *frameworkBundleID = @"com.iwazowski.cbsdk-login";
    NSBundle *frameworkBundle = [NSBundle bundleWithIdentifier:frameworkBundleID];
    CBSignupViewController *signupScreen = [[CBSignupViewController alloc] initWithNibName:@"CBSignupViewController" bundle:frameworkBundle];
    
    // Animation transition
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFade;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    [self.navigationController pushViewController:signupScreen animated:NO];
    [self removeFromParentViewController];
}

- (IBAction)forgotpsswrdViewController:(id)sender
{
    NSString *frameworkBundleID = @"com.iwazowski.cbsdk-login";
    NSBundle *frameworkBundle = [NSBundle bundleWithIdentifier:frameworkBundleID];
    CBForgotPsswrdViewController *forgotpsswrdScreen = [[CBForgotPsswrdViewController alloc] initWithNibName:@"CBForgotPsswrdViewController" bundle:frameworkBundle];
    
    // Animation transition
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFade;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    [self.navigationController pushViewController:forgotpsswrdScreen animated:NO];
}

- (IBAction)cancelLoginViewController:(id)sender
{
    NSLog(@"CBLoginViewController - dismissed");
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)loginButtonPressed:(id)sender
{
    // Everything seems to be ok so go on with the signup process
    NSLog(@"loginButtonPressed");
    NSMutableDictionary *user = [[NSMutableDictionary alloc] initWithCapacity:5];
    [user setObject:self.username.text  forKey:@"username"];
    [user setObject:self.password.text  forKey:@"password"];
    self.loginDetails = [[NSDictionary alloc] initWithDictionary:user];
    
    CBloginclass *loginclass = [[CBloginclass alloc] initWithDict:user];
    [loginclass login:user];
}

#pragma mark -
#pragma mark App Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Startup the interactive recognizer for swipe gestures
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    // Set CBWelcomeViewController Logos and Titles.
    NSString *frameworkBundleID = APP_BUNDLE_IMAGE;
    NSBundle *frameworkBundle = [NSBundle bundleWithIdentifier:frameworkBundleID];
    _logoImageWVC.image = [UIImage imageNamed:APP_LOGO_IMAGE inBundle:frameworkBundle compatibleWithTraitCollection:nil];
    _appTitleWVC.text = APP_TITLE;

}

- (void)viewDidAppear:(BOOL)animated
{
    // Startup the interactive recognizer for swipe gestures
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -
#pragma mark Delegete Methods

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self.navigationController pushViewController:viewController animated:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

@end
