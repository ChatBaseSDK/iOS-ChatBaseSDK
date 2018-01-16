//
//  CBRegisterRequests.m
//  chatbase.sdk.ios
//
//  Created by Diego Jimenez Martinez on 29/9/17.
//  Copyright © 2017 chatbase.co. All rights reserved.
//

#import "CBloginclass.h"
#import "cbsdk_login.h"

@implementation CBloginclass

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    
    if(self){
        self.data = [[NSDictionary alloc] initWithDictionary: dict];
    }
    return self;
}

// public function REGISTER($username, $firstname, $surname, $email, $password, $pri_ip)
- (void)signup:(NSDictionary *)data
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //NSString *headURL = @"http://192.168.0.196/cbsdk/mobilify/signup.php";
    NSString *headURL = [NSString stringWithFormat:@"%@/cbsdk/mobilify/signup.php", HTTP_SERVER_MAIN];
    NSString *username   = [data objectForKey: @"username"];
    NSString *firstname  = [data objectForKey: @"firstname"];
    NSString *surname    = [data objectForKey: @"surname"];
    NSString *email      = [data objectForKey: @"email"];
    NSString *password   = [data objectForKey: @"password"];
    NSURL *encodedURL    = [NSURL URLWithString:[NSString stringWithFormat:@"%@?username=%@&firstname=%@&surname=%@&email=%@&password=%@",headURL,username,firstname,surname,email,password]];
    [request setURL:encodedURL];
    [request setHTTPMethod:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
                                                if (data == nil) {
                                                    NSLog(@"Signup dispatch error");
                                                }else{
                                                    // Encode NSData to Nsstring
                                                    NSString *datastr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                    NSLog(@"%@", datastr);
                                                    // All instances of signupClassNotification will be notified
                                                    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:datastr forKey:@"response"];
                                                    [[NSNotificationCenter defaultCenter] postNotificationName: @"signupClassNotification" object:nil userInfo:userInfo];
                                                }
                                            }];
    [task resume];
}

// public function LOGIN($username, $password, $ip)
- (void)login:(NSDictionary *)data
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //NSString *headURL = @"http://192.168.0.196/cbsdk/mobilify/login.php";
    NSString *headURL = [NSString stringWithFormat:@"%@/cbsdk/mobilify/login.php", HTTP_SERVER_MAIN];
    NSString *username   = [data objectForKey: @"username"];
    NSString *password   = [data objectForKey: @"password"];
    NSURL *encodedURL    = [NSURL URLWithString:[NSString stringWithFormat:@"%@?username=%@&password=%@",headURL,username,password]];
    [request setURL:encodedURL];
    [request setHTTPMethod:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
                                                if (data == nil) {
                                                    NSLog(@"login dispatch error");
                                                }else{
                                                    // Encode NSData to Nsstring
                                                    NSString *datastr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                    NSLog(@"%@", datastr);
                                                    // All instances of loginClassNotification will be notified
                                                    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:datastr forKey:@"response"];
                                                    [[NSNotificationCenter defaultCenter] postNotificationName: @"loginClassNotification" object:nil userInfo:userInfo];
                                                }
                                            }];
    [task resume];
}


// public function LOGIN($username, $password, $ip)
- (void)autologin:(NSDictionary *)data
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //NSString *headURL = @"http://192.168.0.196/cbsdk/mobilify/login.php";
    NSString *headURL = [NSString stringWithFormat:@"%@/cbsdk/mobilify/login.php", HTTP_SERVER_MAIN];
    NSString *username   = [data objectForKey: @"username"];
    NSString *password   = [data objectForKey: @"password"];
    NSURL *encodedURL    = [NSURL URLWithString:[NSString stringWithFormat:@"%@?username=%@&password=%@",headURL,username,password]];
    [request setURL:encodedURL];
    [request setHTTPMethod:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
                                                if (data == nil) {
                                                    NSLog(@"login dispatch error");
                                                }else{
                                                    // Encode NSData to Nsstring
                                                    NSString *datastr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                    NSLog(@"%@", datastr);
                                                    // All instances of loginClassNotification will be notified
                                                    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:datastr forKey:@"response"];
                                                    [[NSNotificationCenter defaultCenter] postNotificationName: @"autologinClassNotification" object:nil userInfo:userInfo];
                                                }
                                            }];
    [task resume];
}

// public function LOGOUT()
- (void)logout
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //NSString *headURL = @"http://192.168.0.196/cbsdk/mobilify/logout.php";
    NSString *headURL = [NSString stringWithFormat:@"%@/cbsdk/mobilify/logout.php", HTTP_SERVER_MAIN];
    NSURL *encodedURL    = [NSURL URLWithString:[NSString stringWithFormat:@"%@",headURL]];
    [request setURL:encodedURL];
    [request setHTTPMethod:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
                                                if (data == nil) {
                                                    NSLog(@"Request logout: Logout dispatch error");
                                                }else{
                                                    // Encode NSData to Nsstring
                                                    NSString *datastr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                    NSLog(@"Request logout:");
                                                    NSLog(@"%@", datastr);
                                                    // All instances of loginClassNotification will be notified
                                                    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:datastr forKey:@"response"];
                                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"logoutUserNotificationRequest" object:userInfo];
                                                }
                                            }];
    [task resume];
}

@end
