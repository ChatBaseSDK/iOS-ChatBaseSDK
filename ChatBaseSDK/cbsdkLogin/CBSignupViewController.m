//
//  CBSignupViewController.m
//  chatbase.sdk.ios
//
//  Created by Diego Jimenez Martinez on 23/9/17.
//  Copyright © 2017 chatbase.co. All rights reserved.
//

#import "CBSignupViewController.h"
#import "CBLoginViewController.h"

#import "CBloginclass.h"

#import "cbsdk_login.h"

@interface CBSignupViewController ()<UIGestureRecognizerDelegate, UITextFieldDelegate>

@property(nonatomic, retain) IBOutlet UITextField *username;
@property(nonatomic, retain) IBOutlet UITextField *firstname;
@property(nonatomic, retain) IBOutlet UITextField *surname;
@property(nonatomic, retain) IBOutlet UITextField *email;
@property(nonatomic, retain) IBOutlet UITextField *password;
@property(nonatomic, retain) IBOutlet UISwitch *agreementSwitch;
@property(nonatomic, retain) IBOutlet UIButton *termsButton;
@property(nonatomic, retain) IBOutlet UIButton *signupButton;
@property(nonatomic, retain) IBOutlet UIButton *gotologinButton;

@property(nonatomic, retain) IBOutlet UIButton *cancelButton;

@property (nonatomic, retain) IBOutlet UIImageView *logoImageWVC;
@property (nonatomic, retain) IBOutlet UILabel *appTitleWVC;
@property (nonatomic, retain) IBOutlet UIButton *appTermsWVC;

- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)cancelSignupViewController:(id)sender;

- (IBAction)signupButtonPressed:(id)sender;

- (IBAction)textFieldValueChanged:(id)sender;

@end

@implementation CBSignupViewController

#pragma mark -
#pragma mark IBActions

- (IBAction)loginButtonPressed:(id)sender
{
    NSString *frameworkBundleID = @"com.iwazowski.cbsdk-login";
    NSBundle *frameworkBundle = [NSBundle bundleWithIdentifier:frameworkBundleID];
    CBLoginViewController *loginScreen = [[CBLoginViewController alloc] initWithNibName:@"CBLoginViewController" bundle:frameworkBundle];
    
    // Animation transition
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFade;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];

    [self.navigationController pushViewController:loginScreen animated:NO];
    [self removeFromParentViewController];
}

- (IBAction)cancelSignupViewController:(id)sender
{
    NSLog(@"CBSignupViewController - dismissed");
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)signupButtonPressed:(id)sender
{
    // Check if every textfield is ok
    if([[self validateTextField1by1] length]){
        NSLog(@"signupButtonPressed: Some text inputs are wrong");
        return;
    }
    // Check Switch Agreement
    if(!self.agreementSwitch.isOn){
        NSLog(@"signupButtonPressed: Switch Agreement is Off");
        return;
    }
    
    // Everything seems to be ok so go on with the signup process
    NSLog(@"signupButtonPressed");
    NSMutableDictionary *user = [[NSMutableDictionary alloc] initWithCapacity:5];
    [user setObject:self.username.text  forKey:@"username"];
    [user setObject:self.firstname.text forKey:@"firstname"];
    [user setObject:self.surname.text   forKey:@"surname"];
    [user setObject:self.email.text     forKey:@"email"];
    [user setObject:self.password.text  forKey:@"password"];
    
    self.signupDetails = [[NSDictionary alloc] initWithDictionary:user];
    
    CBloginclass *loginclass = [[CBloginclass alloc] initWithDict:user];
    [loginclass signup:user];
}

- (NSString *)validateTextField1by1
{
    // Any textfield must be empty
    if(self.username.text.length < 1)
        return @"This field cannot be empty.";
    if(self.firstname.text.length < 1)
        return @"This field cannot be empty.";
    if(self.surname.text.length < 1)
        return @"This field cannot be empty.";
    if(self.email.text.length < 1)
        return @"This field cannot be empty.";
    if(self.password.text.length < 1)
        return @"This field cannot be empty.";
    
    // Minimum username length
    if (self.username.text.length < 5)
        return @"Your username is too short.";
    
    // Check Email string format
    if (![self validateEmail:self.email.text])
        return @"Email is not in correct format.";
    
    // Minimum password length
    if (self.password.text.length <= 6)
        return @"Your username is too short.";
    
    // Return if Everything is fine
    return nil;
}

- (NSString *)validateTextField:(UITextField *)text
{
    // NSLog(@"validateTextField: %@", text.text);
    if(text.tag == 1)
        if (text.text.length < 5)
            return @"Your username is too short.";
    
    if(text.tag == 4)
        if (![self validateEmail:text.text])
            return @"Email is not in correct format.";
    
    if(text.tag == 5)
        if (text.text.length <= 6)
            return @"Your password is too short.";
    
    if(text.text.length < 1)
        return @"This field cannot be empty.";
    
    return nil;
}

-(BOOL) validateEmail:(NSString*) emailString
{
    NSString *regExPattern = @"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
    if (regExMatches == 0) {
        return NO;
    }else{
        return YES;
    }
}

#pragma mark -
#pragma mark App Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Startup the interactive recognizer for swipe gestures
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    // Set cursor and user attention to the username textfield
    [self.username becomeFirstResponder];
    
    // Set CBWelcomeViewController Logos and Titles.
    NSString *frameworkBundleID = APP_BUNDLE_IMAGE;
    NSBundle *frameworkBundle = [NSBundle bundleWithIdentifier:frameworkBundleID];
    _logoImageWVC.image = [UIImage imageNamed:APP_LOGO_IMAGE inBundle:frameworkBundle compatibleWithTraitCollection:nil];
    _appTitleWVC.text = APP_TITLE;
    [_appTermsWVC setTitle:APP_TERMS forState:UIControlStateNormal];
    
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
#pragma mark Gesture Delegete Methods

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self.navigationController pushViewController:viewController animated:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

#pragma mark -
#pragma mark UITextField Delegete Methods

- (BOOL)setupTextField:(UITextField *)textField
{
    NSString *validate = [self validateTextField:textField];
    NSLog(@"validateTextField - %@", validate);
    
    if(validate!=nil){
        textField.layer.shadowColor = [[UIColor redColor] CGColor];
        textField.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        textField.layer.shadowOpacity = 0.65f;
        textField.layer.shadowRadius = 1.0f;
        textField.layer.cornerRadius = 5.0f;
        textField.layer.borderWidth = 1.5f;
        textField.layer.borderColor = [[UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.65f] CGColor];
        return NO;
    }
    textField.layer.shadowColor = [[UIColor clearColor] CGColor];
    textField.layer.borderColor  = [[UIColor clearColor] CGColor];
    return YES;
}

- (IBAction)textFieldValueChanged:(id)sender
{
    UITextField *textField = (UITextField *)sender;
    
    // Change UITextField apparence when worng input
    [self setupTextField:textField];

    return;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // Change UITextField apparence when worng input
    if(![self setupTextField:textField])
        return false;
    
    switch (textField.tag) {
        case 1:
            [self.firstname setEnabled:YES];
            [self.firstname becomeFirstResponder];
            break;
        case 2:
            [self.surname setEnabled:YES];
            [self.surname becomeFirstResponder];
            break;
        case 3:
            [self.email setEnabled:YES];
            [self.email becomeFirstResponder];
            break;
        case 4:
            [self.password setEnabled:YES];
            [self.password becomeFirstResponder];
            break;
        default:
            [self.password resignFirstResponder];
            break;
    }

    return true;
}

@end
