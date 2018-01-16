//
//  CBRegisterRequests.h
//  chatbase.sdk.ios
//
//  Created by Diego Jimenez Martinez on 29/9/17.
//  Copyright © 2017 chatbase.co. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBloginclass : NSObject

@property (nonatomic,strong) NSDictionary *data;

// class initialization
- (id)initWithDict:(NSDictionary *)dict;

// public function REGISTER($username, $firstname, $surname, $email, $password, $pri_ip)
- (void)signup:(NSDictionary *)data;
// public function LOGIN($username, $password, $ip)
- (void)login:(NSDictionary *)data;
- (void)autologin:(NSDictionary *)data; // this is a modification for autologin feature.
// public function LOGOUT()
- (void)logout;

@end
