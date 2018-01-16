//
//  CBHomeViewController.m
//  cbsdk.home
//
//  Created by Diego Jimenez Martinez on 11/12/17.
//  Copyright © 2017 PGDMobile. All rights reserved.
//

#import "CBHomeViewController.h"

#import "LeftMenuViewController.h"
#import "LeftMenuPresentation.h"
#import "LeftMenuTransition.h"

@interface CBHomeViewController ()<UIGestureRecognizerDelegate, UIViewControllerTransitioningDelegate>

@property id percentDrivenTransition;
@property id dismissDrivenTransition;

@property (nonatomic, strong) LeftMenuViewController *leftMenu;
@property (nonatomic, strong) LeftMenuTransition     *presentTransition;
@property (nonatomic, strong) LeftMenuTransition     *dismissTransition;

@end

@implementation CBHomeViewController

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"CBHomeViewController: viewDidAppear");
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Set title and state for our custom NavBar.
    self.homeNavBarTitle.title = @".: Home :.";
    
    // Left Menu Pan Gestures Recognizer Configuration
    [self createVC];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Cretate LeftMenu

- (void)createVC
{
    self.presentTransition = [[LeftMenuTransition alloc] initWithIsPresent:YES];
    self.dismissTransition = [[LeftMenuTransition alloc] initWithIsPresent:NO];
    
    UIScreenEdgePanGestureRecognizer *edgePanGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanGesture:)];
    edgePanGesture.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgePanGesture];
    
    // Load welcomeViewController for user credentials
    NSString *frameworkBundleID = @"com.iwazowski.ChatBaseSDK";
    NSBundle *frameworkBundle = [NSBundle bundleWithIdentifier:frameworkBundleID];
    self.leftMenu = [[LeftMenuViewController alloc] initWithNibName:@"LeftMenuViewController" bundle:frameworkBundle];
    self.leftMenu.view.backgroundColor = [UIColor whiteColor];
    self.leftMenu.modalPresentationStyle = UIModalPresentationCustom;
    self.leftMenu.transitioningDelegate = self;
    
    UIPanGestureRecognizer *swipeGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanDismissGesture:)];
    [self.leftMenu.view addGestureRecognizer:swipeGesture];
}

- (IBAction)presentView:(id)sender
{
    [self presentViewController:self.leftMenu animated:YES completion:nil];
}


#pragma mark - Gesture Recognizer Delegete Methods

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self.navigationController pushViewController:viewController animated:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
}

#pragma mark - PanGestures Create and Dismiss Methods

- (void)edgePanGesture:(UIScreenEdgePanGestureRecognizer *)edgePan
{
    CGPoint point = [edgePan translationInView:self.view];
    CGFloat w = self.view.bounds.size.width;
    
    CGFloat progress = point.x / w ;
    
    // NSLog(@"point:%@, %.2f, %.2f", NSStringFromCGPoint(point), w, progress);
    // NSLog(@"%f", progress);
    
    if (edgePan.state == UIGestureRecognizerStateBegan) {
        self.presentTransition.isPercentDriven = YES;
        self.percentDrivenTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self presentViewController:self.leftMenu animated:YES completion:nil];
    } else if (edgePan.state == UIGestureRecognizerStateChanged) {
        [self.percentDrivenTransition updateInteractiveTransition:progress];
    } else if (edgePan.state == UIGestureRecognizerStateCancelled || edgePan.state == UIGestureRecognizerStateEnded) {
        if (progress > 0.5) {
            [self.percentDrivenTransition finishInteractiveTransition];
        } else {
            [self.percentDrivenTransition cancelInteractiveTransition];
        }
        self.percentDrivenTransition = nil;
        self.presentTransition.isPercentDriven = NO;
    }
}

- (void)edgePanDismissGesture:(UIPanGestureRecognizer *)edgePan
{
    CGPoint point = [edgePan translationInView:self.view];
    CGFloat w = PRESENTATION_W;//self.view.bounds.size.width;
    CGPoint vel = [edgePan velocityInView:self.view];
    
    static BOOL perform = NO;
    if (vel.x < 0 && !perform) {
        perform = YES;
    }
    else {
    }
    
    CGFloat progress = -point.x / PRESENTATION_W;
    
    // NSLog(@"point:%@, %.2f, %.2f", NSStringFromCGPoint(point), w, progress);
    // NSLog(@"%f", progress);
    
    if (edgePan.state == UIGestureRecognizerStateBegan && perform) {
        self.dismissTransition.isPercentDriven = YES;
        self.dismissDrivenTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self.leftMenu dismissViewControllerAnimated:YES completion:nil];
    } else if (edgePan.state == UIGestureRecognizerStateChanged) {
        [self.dismissDrivenTransition updateInteractiveTransition:progress];
    } else if (edgePan.state == UIGestureRecognizerStateCancelled || edgePan.state == UIGestureRecognizerStateEnded) {
        perform = NO;
        if (progress > 0.3) {
            [self.dismissDrivenTransition finishInteractiveTransition];
        } else {
            [self.dismissDrivenTransition cancelInteractiveTransition];
        }
        self.dismissDrivenTransition = nil;
        self.dismissTransition.isPercentDriven = NO;
    }
}


#pragma mark - UIViewControllerTransitioningDelegate

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    return [[LeftMenuPresentation alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self.presentTransition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self.dismissTransition;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return self.percentDrivenTransition;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return self.dismissDrivenTransition;
}

@end
