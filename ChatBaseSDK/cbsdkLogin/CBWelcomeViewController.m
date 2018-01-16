//
//  CBWelcomeViewController.m
//  
//
//  Created by Diego Jimenez Martinez on 22/9/17.
//

#import "CBWelcomeViewController.h"

#import "CBSignupViewController.h"
#import "CBLoginViewController.h"

#import "CBloginclass.h"

#import "EHPlainAlert.h"

#import "cbsdk_login.h"

#import <CoreText/CoreText.h>
#import <CoreData/CoreData.h>

@interface CBWelcomeViewController ()<UIGestureRecognizerDelegate>
{
    CBSignupViewController *signupScreen;
    CBLoginViewController  *loginScreen;
}

@property (strong) NSMutableArray *userArray;
@property (strong) NSMutableDictionary *currentUser;
@property (strong) NSManagedObject *contactdb;

@property (nonatomic, retain) IBOutlet UIButton *loginButon;
@property (nonatomic, retain) IBOutlet UIButton *signupButon;

@property (nonatomic, retain) IBOutlet UIImageView *logoImageWVC;
@property (nonatomic, retain) IBOutlet UITextView *appDescriptionWVC;
@property (nonatomic, retain) IBOutlet UILabel *appTitleWVC;
@property (nonatomic, retain) IBOutlet UILabel *appSubtitleWVC;

- (IBAction)signupButtonPressed:(id)sender;
- (IBAction)loginButtonPressed:(id)sender;

@end

@implementation CBWelcomeViewController

#pragma mark -
#pragma mark IBAction methods

- (IBAction)signupButtonPressed:(id)sender
{
    NSString *frameworkBundleID = @"com.iwazowski.cbsdk-login";
    NSBundle *frameworkBundle = [NSBundle bundleWithIdentifier:frameworkBundleID];
    
    signupScreen = [[CBSignupViewController alloc] initWithNibName:@"CBSignupViewController" bundle:frameworkBundle];
    [self.navigationController pushViewController:signupScreen animated:YES];
}

- (IBAction)loginButtonPressed:(id)sender
{
    NSString *frameworkBundleID = @"com.iwazowski.cbsdk-login";
    NSBundle *frameworkBundle = [NSBundle bundleWithIdentifier:frameworkBundleID];
    
    loginScreen = [[CBLoginViewController alloc] initWithNibName:@"CBLoginViewController" bundle:frameworkBundle];
    [self.navigationController pushViewController:loginScreen animated:YES];
}

#pragma mark -
#pragma mark App FLow Cycle

- (void)CBWelcomeViewControllerInitialization:(NSInteger)style
{
    // Set CBWelcomeViewController Alerts
    _style = style;
    
    // NSNotificationCenter Observbers for login and signup notifications from CBloginclass
    //... login observer
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginclassLoginRequestResponse:)
                                                 name:@"loginClassNotification"
                                               object:nil];
    //... signup observer
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginclassSignupRequestResponse:)
                                                 name:@"signupClassNotification"
                                               object:nil];
    //... autologin observer
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(autologinclassLoginRequestResponse:)
                                                 name:@"autologinClassNotification"
                                               object:nil];
    //... logout observers
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginclassLogoutRequest:)
                                                 name:@"logoutClassNotification"
                                               object:nil];
    //...
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginclassLogoutRequestResponse:)
                                                 name:@"logoutUserNotificationRequest"
                                               object:nil];
    
    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    self.userArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    NSString *datastr = @"Initializating...";
    // Check DataCore User, if no user found, shows Login/Register view
    if(self.userArray.count <= 0){
        NSLog(@"No users found.");
        // No user found, app must wait for login or signup.
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"nouserfound" forKey:@"response"];
        [[NSNotificationCenter defaultCenter] postNotificationName: @"CBWelcomeViewControllerNotification" object:nil userInfo:userInfo];
        
    // If there is an User load app flow normally with that user data from CoreData
    }else if(self.userArray.count == 1){
        NSLog(@"User found.");
        // One user found, app will try to make an autologin and will continue to homescreen.
        // Send notification for continue to Login and Signup.
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"autologin" forKey:@"response"];
        [[NSNotificationCenter defaultCenter] postNotificationName: @"CBWelcomeViewControllerNotification" object:nil userInfo:userInfo];
        
        // Current user data from CoreData
        NSManagedObject *selectedUser = [self.userArray objectAtIndex:0];
        NSLog(@"%ld", [[selectedUser valueForKey:@"id"] integerValue]);
        NSLog(@"%@", [selectedUser valueForKey:@"username"]);
        NSLog(@"%@", [selectedUser valueForKey:@"passwordd"]);
        NSLog(@"%@", [selectedUser valueForKey:@"password"]);   // If user registration was done in the WebApp,
        // password is not set in DataCore at this point.
        // Make a login with the stored credentials.
        NSString *u_id = [selectedUser valueForKey:@"username"];
        NSString *u_ps = [selectedUser valueForKey:@"passwordd"];
        
        // Everything seems to be ok so go on with the signup process
        NSLog(@"Autologin at start time");
        NSMutableDictionary *user = [[NSMutableDictionary alloc] initWithCapacity:5];
        [user setObject:u_id forKey:@"username"];
        [user setObject:u_ps forKey:@"password"];

        CBloginclass *loginclass = [[CBloginclass alloc] initWithDict:user];
        [loginclass autologin:user];
        
    // If something went wrong... Ooops! make some adjust here xD
    }else{
        //NSLog(@"Found %ld users.", self.userArray.count);
        NSLog(@"Found more than one user.");
        // TODO: Here we can show an alternate login window with all the possible users,
        //       but it is supose that the app is just for one user at a time.
        //return;
        
        // Meanwhile, delete all previous users and show login and registration view.
        [self deleteAllObjects:@"User"];
        // More No user found, app must wait for login or signup.
        // Send notification for continue to Login and Signup.
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"nouserfound" forKey:@"response"];
        [[NSNotificationCenter defaultCenter] postNotificationName: @"CBWelcomeViewControllerNotification" object:nil userInfo:userInfo];
    }
}

- (void) dealloc
{
    // If you don't remove yourself as an observer, the Notification Center
    // will continue to try and send notification objects to the deallocated
    // object.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"CBWelcomeViewController: viewDidAppear");
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidLoad
{
    NSLog(@"CBWelcomeViewController: viewDidLoad");
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Startup the interactive recognizer for swipe gestures
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    // Set Current Bundle Pointer to use Custom Fonts and Images
    NSString *frameworkBundleID = APP_BUNDLE_IMAGE;
    NSBundle *frameworkBundle = [NSBundle bundleWithIdentifier:frameworkBundleID];
    
    // Load Custom Font
    NSString *fontPath = [frameworkBundle pathForResource:@"Lobster_1.4" ofType:@"otf"];
    NSData *inData = [NSData dataWithContentsOfFile:fontPath];
    CFErrorRef error;
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)inData);
    CGFontRef font = CGFontCreateWithDataProvider(provider);
    if (! CTFontManagerRegisterGraphicsFont(font, &error)) {
        CFStringRef errorDescription = CFErrorCopyDescription(error);
        NSLog(@"Failed to load font: %@", errorDescription);
        CFRelease(errorDescription);
    }
    
    // Set CBWelcomeViewController Logos and Titles.
    _logoImageWVC.image = [UIImage imageNamed:APP_LOGO_IMAGE inBundle:frameworkBundle compatibleWithTraitCollection:nil];
    _appDescriptionWVC.text = APP_DESCRIPTION;
    _appTitleWVC.text = APP_TITLE;
    [_appTitleWVC setFont:[UIFont fontWithName:@"Lobster1.4" size:42.0]];
    _appSubtitleWVC.text = APP_SUBTITLE;
    
    
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

#pragma mark - CBloginClassDelegate Methods

- (void)loginclassLoginRequestResponse:(NSNotification *) notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSString *res = [userInfo objectForKey:@"response"];
    NSData *jsonData = [res dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:nil error:&e];
    NSLog(@"loginJSON: %@",dict);
    NSString *response = [dict objectForKey:@"response"];
    if([response isEqualToString:@"Successfull"]){
        _userLSDetails = [[NSMutableDictionary alloc] initWithDictionary:dict];
        [_userLSDetails setObject:loginScreen.loginDetails forKey:@"logincredentials"];
        NSLog(@"%@", _userLSDetails);
        // Avoid autolayout corruption and very big warning and timeout
        dispatch_async(dispatch_get_main_queue(), ^{
            //...
            /* Save or Update User in CoreData */
            [self saveOrUpdateCoreDataUser:1];
            //...
            [self.navigationController popToRootViewControllerAnimated:YES];
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"reloadUsersDataFromCoreDataWithLoginDetails" object:nil];
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Successfull" forKey:@"response"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CBWelcomeViewControllerNotification" object:nil userInfo:userInfo];
        });
        
    }else{
        NSLog(@"%@",response);
        if(!_style)return; // If Style is set to 0, no alert will be shown.
        [EHPlainAlert updateAlertPosition:ViewAlertPositionTop];
        [EHPlainAlert showAlertWithTitle:@"Check this out..." message:response type:ViewAlertInfo];
    }
}

- (void)loginclassSignupRequestResponse:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSString *res = [userInfo objectForKey:@"response"];
    NSData *jsonData = [res dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:nil error:&e];
    NSLog(@"Registration JSON: %@",dict);
    NSString *response = [dict objectForKey:@"response"];
    if([response isEqualToString:@"Successfull"]){
        _userLSDetails = [[NSMutableDictionary alloc] initWithDictionary:dict];
        [_userLSDetails setObject:signupScreen.signupDetails forKey:@"registrationcredentials"];
        //NSLog(@"%@", _userLSDetails);
        // Avoid autolayout corruption and very big warning and timeout
        dispatch_async(dispatch_get_main_queue(), ^{
            //...
            /* Save or Update User in CoreData */
            [self saveOrUpdateCoreDataUser:2];
            //...
            [self.navigationController popToRootViewControllerAnimated:YES];
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"reloadUsersDataFromCoreDataWithSignupDetails" object:nil];
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Successfull" forKey:@"response"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CBWelcomeViewControllerNotification" object:nil userInfo:userInfo];
        });
        
    }else{
        //NSLog(@"%@",response);
        if(!_style)return; // If Style is set to 0, no alert will be shown.
        [EHPlainAlert updateAlertPosition:ViewAlertPositionTop];
        [EHPlainAlert showAlertWithTitle:@"Check this out..." message:response type:ViewAlertInfo];
    }
}

// Receives the autologin request response
- (void)autologinclassLoginRequestResponse:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSString *res = [userInfo objectForKey:@"response"];
    NSData *jsonData = [res dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:nil error:&e];
    NSLog(@"loginJSON: %@",dict);
    NSString *response = [dict objectForKey:@"response"];
    if([response isEqualToString:@"Successfull"]){
        // Here it is not neccesary update user credentials because we are using the stored data.
        // We are just redirecting the app to the root controller and send it a Notification.
        [self.navigationController popToRootViewControllerAnimated:YES];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"autologin" forKey:@"response"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CBWelcomeViewControllerNotification" object:nil userInfo:userInfo];
        
    }else{
        //NSLog(@"%@",response);
        if(!_style)return; // If Style is set to 0, no alert will be shown.
        [EHPlainAlert updateAlertPosition:ViewAlertPositionTop];
        [EHPlainAlert showAlertWithTitle:@"Check this out..." message:response type:ViewAlertInfo];
        // Something went worng so do something here.
        
    }
}

- (void)loginclassLogoutRequest:(NSNotification *)notification
{
    NSLog(@"logout confirmation");
    CBloginclass *loginclass = [[CBloginclass alloc] initWithDict:nil];
    [loginclass logout];
}

- (void)loginclassLogoutRequestResponse:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self deleteAllObjects:@"User"];
        [self.navigationController popToRootViewControllerAnimated:YES];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"logout" forKey:@"response"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CBWelcomeViewControllerNotification" object:nil userInfo:userInfo];
    });
}

#pragma mark - CoreData stack

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (BOOL)coreDataUserExist:(NSInteger)uid
{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    [request setFetchLimit:1];
    [request setPredicate:[NSPredicate predicateWithFormat:@"id == %ld", uid]];
    
    NSError *error = nil;
    NSUInteger count = [managedObjectContext countForFetchRequest:request error:&error];

    if (count){
        return YES;
    }else{
        return NO;
    }
}

- (void)saveOrUpdateCoreDataUser:(NSInteger)type
{
    switch (type) {
        case 0:
            break;
            
        case 1: // Login
            self.currentUser = [[NSMutableDictionary alloc] initWithDictionary:_userLSDetails];
            NSLog(@"%@", self.currentUser);
            
            // Check if the user is already in the database
            if([self coreDataUserExist:[[[self.currentUser objectForKey:@"userdetails"] objectForKey:@"id"] integerValue]]){
                // If user exists, update its info in database.
                NSLog(@"saveOrUpdateCoreDataUser:User already exists in CoreData.");
                // TODO: Edit user data.
                // Making it fast
                // 1.- Delete all data
                [self deleteAllObjects:@"User"];
                // 2.- Add data as new user
                // Create a new user
                NSManagedObjectContext *context = [self managedObjectContext];
                NSManagedObject *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
                [newUser setValue:@([[[self.currentUser objectForKey:@"userdetails"] objectForKey:@"id"] integerValue]) forKey:@"id"];
                [newUser setValue:[[self.currentUser objectForKey:@"userdetails"] objectForKey:@"username"] forKey:@"username"];
                [newUser setValue:[[self.currentUser objectForKey:@"userdetails"] objectForKey:@"password"] forKey:@"password"];
                [newUser setValue:[[self.currentUser objectForKey:@"logincredentials"] objectForKey:@"password"] forKey:@"passwordd"];
                
                // Save context
                NSError *error;
                [context save:&error];
                
            }else{
                // If the user does not exists, create a new one.
                NSLog(@"saveOrUpdateCoreDataUser:User does not exists in CoreData.");
                
                // Create a new user
                NSManagedObjectContext *context = [self managedObjectContext];
                NSManagedObject *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
                [newUser setValue:@([[[self.currentUser objectForKey:@"userdetails"] objectForKey:@"id"] integerValue]) forKey:@"id"];
                [newUser setValue:[[self.currentUser objectForKey:@"userdetails"] objectForKey:@"username"] forKey:@"username"];
                [newUser setValue:[[self.currentUser objectForKey:@"userdetails"] objectForKey:@"password"] forKey:@"password"];
                [newUser setValue:[[self.currentUser objectForKey:@"logincredentials"] objectForKey:@"password"] forKey:@"passwordd"];
                
                // Save context
                NSError *error;
                [context save:&error];
            }
            break;
            
        case 2:
            self.currentUser = [[NSMutableDictionary alloc] initWithDictionary:_userLSDetails];
            NSLog(@"%@", self.currentUser);
            [self makeAnAutologinFromSignupCredentials];
            break;
            
        default:
            break;
    }
    
}

- (void)makeAnAutologinFromSignupCredentials
{
    self.currentUser = [[NSMutableDictionary alloc] initWithDictionary:_userLSDetails];
    NSString *u_un = [[self.currentUser objectForKey:@"registrationcredentials"] objectForKey:@"username"];
    NSString *u_ps = [[self.currentUser objectForKey:@"registrationcredentials"] objectForKey:@"password"];
    // Everything seems to be ok so go on with the signup process
    NSLog(@"Autologin at registration time");
    NSMutableDictionary *user = [[NSMutableDictionary alloc] initWithCapacity:5];
    [user setObject:u_un forKey:@"username"];
    [user setObject:u_ps forKey:@"password"];
    CBloginclass *loginclass = [[CBloginclass alloc] initWithDict:user];
    [loginclass autologin:user];
    
    // Making it fast
    // 1.- Delete all data
    [self deleteAllObjects:@"User"];
    // 2.- Add data as new user
    // Create a new user
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
    [newUser setValue:u_un forKey:@"username"];
    [newUser setValue:u_ps forKey:@"passwordd"];
    
    // Save context
    NSError *error;
    [context save:&error];
}

- (void)deleteAllObjects:(NSString *)entityDescription
{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *managedObject in items) {
        [managedObjectContext deleteObject:managedObject];
        NSLog(@"%@ object deleted",entityDescription);
    }
    if (![managedObjectContext save:&error]) {
        NSLog(@"Error deleting %@ - error:%@",entityDescription,error);
    }
    
}

@end
