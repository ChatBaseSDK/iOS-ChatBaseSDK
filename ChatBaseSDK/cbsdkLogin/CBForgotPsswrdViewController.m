//
//  CBForgotPsswrdViewController.m
//  chatbase.sdk.ios
//
//  Created by Diego Jimenez Martinez on 24/9/17.
//  Copyright © 2017 chatbase.co. All rights reserved.
//

#import "CBForgotPsswrdViewController.h"

#import "cbsdk_login.h"

@interface CBForgotPsswrdViewController ()<UIGestureRecognizerDelegate>

@property(nonatomic, retain) IBOutlet UITextField *email;
@property(nonatomic, retain) IBOutlet UIButton *recoverButton;

@property(nonatomic, retain) IBOutlet UIButton *cancelButton;

@property (nonatomic, retain) IBOutlet UIImageView *logoImageWVC;
@property (nonatomic, retain) IBOutlet UILabel *appTitleWVC;

- (IBAction)cancelLoginViewController:(id)sender;

@end

@implementation CBForgotPsswrdViewController

#pragma mark -
#pragma mark IBActions

- (IBAction)cancelLoginViewController:(id)sender
{
    NSLog(@"CBLoginViewController - dismissed");
    
    // Animation transition
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFade;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark App Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Set CBWelcomeViewController Logos and Titles.
    NSString *frameworkBundleID = APP_BUNDLE_IMAGE;
    NSBundle *frameworkBundle = [NSBundle bundleWithIdentifier:frameworkBundleID];
    _logoImageWVC.image = [UIImage imageNamed:APP_LOGO_IMAGE inBundle:frameworkBundle compatibleWithTraitCollection:nil];
    _appTitleWVC.text = APP_TITLE;
    
    // Startup the interactive recognizer for swipe gestures
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
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
    return NO;
}

@end
